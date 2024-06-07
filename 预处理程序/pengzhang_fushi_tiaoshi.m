I = imread('E:\智能船舶lab2\images2_caijian\image_0001_cropped.jpg');

% 创建结构元素(3x3正方形)
se1 = strel('square', 3);
se2 = strel('square', 5);
se3 = strel('square', 10);

 I_dilated1 = imdilate(I, se1);
 I_dilated2 = imdilate(I_dilated1, se1);
 I_dilated3 = imdilate(I_dilated2, se1);

 figure;imagesc(I);
 figure;imagesc(I_dilated1);
 figure;imagesc(I_dilated2);
 figure;imagesc(I_dilated3);

%% 
N=4;
M=7;

I_eroded = imerode(I_dilated3, se1);
figure;imagesc(I_eroded);

for i=1:N
I_eroded = imerode(I_eroded, se1);
figure;imagesc(I_eroded);
end

for j=1:M
I_eroded = imerode(I_eroded, se1);
figure;imagesc(I_eroded);
end


