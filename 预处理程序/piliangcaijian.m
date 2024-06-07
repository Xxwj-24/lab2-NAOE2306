% 设置输入文件夹路径
input_folder = 'E:\智能船舶lab2\images2';

% 设置输出文件夹路径
output_folder = 'E:\智能船舶lab2\images2_caijian';

% 获取输入文件夹中所有图像文件
file_pattern = fullfile(input_folder, '*.jpg'); % 这里假设要处理的是JPG图像
image_files = dir(file_pattern);

% 遍历所有图像文件
for k = 1:length(image_files)
    % 构造输入图像的完整文件路径
    input_image = fullfile(input_folder, image_files(k).name);
    
    % 读取输入图像
    I = imread(input_image);
 
    
    % 进行裁剪操作
    RGB_gray = I;

   %定位目标，进行图像裁剪，通过两个方向的投影找到最大值，作为目标中心坐标
   bw_RGB=im2bw(RGB_gray );%二值化
   %figure;imagesc(RGB_gray);     % 画出量化后的原图，用于寻找需要裁剪区域的范围
   proj1=sum(bw_RGB);
   proj2=sum(bw_RGB');
   [h1,x_max]=max(proj1);
   [h2,y_max]=max(proj2);
   rect=[800 150 500 300];  %rect=[x_max-300 y_max-400 500 600];  % rect=[xmin ymin width height],即xmin，ymin分别表示矩形框左上角的像素点，width和height表示裁剪的宽度。
   crop_RGB = imcrop(RGB_gray,rect); 




    
    % 构造输出图像的完整文件路径
    [~, basename, ext] = fileparts(image_files(k).name);
    output_image = fullfile(output_folder, [basename '_cropped' ext]);
    
    % 保存裁剪后的图像
    imwrite(crop_RGB, output_image);
end