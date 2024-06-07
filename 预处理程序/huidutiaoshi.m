inputImage = imread('E:\智能船舶lab2\testfile\1\image_0002.jpg'); % 替换为实际图像路径

% 检查图像是否为灰度图像，如果不是则转换为灰度图像
if size(inputImage, 3) == 3
    grayImage = rgb2gray(inputImage); % 转换为灰度图像
else
    grayImage = inputImage;
end

figure;
imshow(grayImage, []);

bw_I=im2bw(grayImage);%二值化
   %figure;imagesc(RGB_gray);% 画出量化后的原图，用于寻找需要裁剪区域的范围
   proj1=sum(bw_I);
   proj2=sum(bw_I');
   [h1,x_max]=max(proj1);
   [h2,y_max]=max(proj2);
   %rect=[800 150 500 400];  
   rect=[x_max-220 y_max+150 400 400];  % rect=[xmin ymin width height],即xmin，ymin分别表示矩形框左上角的像素点，width和height表示裁剪的宽度。
   crop_I= imcrop(grayImage,rect); 


% 直方图均衡化
% equalizedImage = histeq(grayImage);
% % subplot(2,3,2);
% imshow(equalizedImage);
% title('直方图均衡化');

% 显示直方图
% subplot(2,3,5);
% imhist(equalizedImage);
% title('直方图均衡化后的直方图');

% 对比度拉伸
% 对比度拉伸的参数可以根据实际情况调整
% low_in = double(min(grayImage(:))) / 255;
% high_in = double(max(grayImage(:))) / 255;
low_in =0.4;
high_in =0.7;
contrastStretchedImage = imadjust(crop_I, [low_in; high_in], []);
figure;imshow(contrastStretchedImage)

se1 = strel('disk', 3);%采用圆形core
se2 = strel('diamond', 2);

I_dilated1 = imdilate(contrastStretchedImage, se1);
%figure;imshow(I_dilated);
I_eroded1 = imerode(I_dilated1,se1);
%figure;imshow(I_eroded);
I_eroded2 = imerode(I_eroded1,se1);
%I_eroded3 = imerode(I_eroded2,se2);
%I_dilated2 = imdilate(I_eroded3, se2);
I_dilated3 = imdilate(I_eroded2, se1);
figure;imshow(I_dilated3);

 II=I_dilated3;
 %II = rgb2gray(II);
%II= edge(II, 'canny');
figure;imagesc(II);
theta = 0:360;
 [R,xp] = radon(II,theta);
iptsetpref('ImshowAxesVisible','on')
figure
imshow(R,[],'Xdata',theta,'Ydata',xp,'InitialMagnification','fit')
axis normal
colormap(gca,jet)
xlabel('\theta (degrees)')
ylabel('x''')
colorbar
iptsetpref('ImshowAxesVisible','off')
% 显示直方图
% subplot(2,3,6);
% imhist(contrastStretchedImage);
% title('对比度拉伸后的直方图');

% 保存增强后的图像
% imwrite(equalizedImage, 'equalized_image.jpg');
% imwrite(contrastStretchedImage, 'contrast_stretched_image.jpg');
% 
% disp('图像增强处理完成并保存为 equalized_image.jpg 和 contrast_stretched_image.jpg');