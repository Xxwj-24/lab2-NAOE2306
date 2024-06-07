%程序合并处理
%从裁剪开始，以原裁剪程序为基础

%% 

% 设置输入文件夹路径
input_folder = 'E:\智能船舶lab2\数据组\单柱\CUT';

% 设置输出文件夹路径
output_folder = 'E:\智能船舶lab2\数据组\单柱\randon-revised-1';

%% 

% 获取输入文件夹中所有图像文件
file_pattern = fullfile(input_folder, '*.jpg');
image_files = dir(file_pattern);

% 遍历所有图像文件
for k = 1:length(image_files)
    % 构造输入图像的完整文件路径
    input_image = fullfile(input_folder, image_files(k).name);
    
    % 读取输入图像
    I = imread(input_image);
    I=im2gray(I);
%% 

   %定位目标，进行图像裁剪，通过两个方向的投影找到最大值，作为目标中心坐标
   bw_I=im2bw(I);%二值化
   %figure;imagesc(RGB_gray);% 画出量化后的原图，用于寻找需要裁剪区域的范围
   proj1=sum(bw_I);
   proj2=sum(bw_I');
   [h1,x_max]=max(proj1);
   [h2,y_max]=max(proj2);
   %rect=[800 150 500 300];  
   rect=[x_max-220 y_max+150 400 400];  % 1
   crop_I= imcrop(I,rect); 
   %figure;imshow(crop_I);

%% 
    %灰度映射,提高对比度,的同时去除低亮度噪声
        
    % 对比度拉伸的参数可以根据实际情况调整
    % low_in = double(min(grayImage(:))) / 255;
    % high_in = double(max(grayImage(:))) / 255;
    low_in =0.4;
    high_in =0.7;
    CS_I= imadjust(crop_I, [low_in; high_in], []);
    %figure;imshow(CS_I);

%% 
    %基本去噪处理

    %开运算
    %腐蚀——>去除图上的经纬线——>膨胀
        se = strel('disk', 4);%采用圆形core，矩阵的大小3~5都有不错的表现，不建议大于5

        se1 = strel('disk', 3);%此两个core是为了处理三柱图像而适配
        se2 = strel('diamond', 2);%此两个core是为了处理三柱图像而适配

    I_dilated1 = imdilate(CS_I, se1);
    I_eroded1 = imerode(I_dilated1,se1);
    I_eroded2 = imerode(I_eroded1,se1);
     %I_eroded3 = imerode(I_eroded2,se2);%此处是为了三柱图像优化而多进行的一轮运算
     %I_dilated2 = imdilate(I_eroded3, se2);%此处是为了三柱图像优化而多进行的一轮运算
    I_dilated3 = imdilate(I_eroded2, se1);
   
    %I_denoised = bwareaopen(I_dilated2, 550);
    %可以去除较小的斑点，但是这里输出的图像只有0和1两个logical类型,后续继续处理会变麻烦，换一个

    %I_denoised = bwpropfilt(I_dilated2, 'Area', [500, Inf]);
    %BI =bwpropfilt(BW,prop,values,specifier,value)这里后面两个参数可以进一步筛选保留的区块,但是这个函数只读取logical类型
   %  %% 
   %  %对于四柱图像，链接件的直线太过于明显，而圆柱亮度很低，考虑用霍夫变换检测出直线成分，直接删除直线成分
   %  % 边缘检测
   %  edges = edge(I_dilated3,'canny');%效果一般，故取消
   %  %edges=I_dilated2;
   %  % 使用霍夫变换检测直线
   %  [H, T, R] = hough(edges);
   %  P = houghpeaks(H, 5, 'threshold', ceil(0.3 * max(H(:))));
   %  lines = houghlines(edges, T, R, P, 'FillGap', 5, 'MinLength', 7);
   %  % % 创建一个二值图像用于保存直线
   %  lineMask = false(size(I_dilated2));
   %  for m = 1:length(lines)
   %  xy = [lines(m).point1; lines(m).point2];
   %  lineMask = lineMask | insertShape(zeros(size(I_dilated2)), 'Line', xy(:)', 'Color', 'white', 'LineWidth', 2);
   %  end
   %  lineMask = lineMask(:,:,1); % 将RGB图像转换为二值图像
   %  % 去除直线
   %  cleanedImage = I_dilated2;
   %  cleanedImage(lineMask) = 0;
   % 
   %  II=cleanedImage;
   % %figure;imshow(II);

    %% 
    %特征提取
    %是否要边缘提取，先测试不进行的结果：
    II=I_dilated3;
    %figure;imagesc(II);
    %II = rgb2gray(II);
    %如果对edge进行提取：
    %II= edge(II, 'canny');
    
    theta = 0:360;
    [R,xp] = radon(II,theta);
    RC = ind2rgb(im2uint8(mat2gray(R)), jet());

    %%
    
    % 构造输出图像的完整文件路径
    [~, basename, ext] = fileparts(image_files(k).name);
    output_image = fullfile(output_folder, [basename 'randon' ext]);
    
    % 保存裁剪后的图像
    imwrite(RC, output_image);
    
end