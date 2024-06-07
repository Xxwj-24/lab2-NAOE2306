% 加载训练好的CNN模型
load('E:\大二下\智能船舶\十四十五周\第15课 图像处理及特征提取算法\CNN声图像分类程序\net_radon0427_sgdm2.mat'); % 替换为您保存模型的路径

% 读取要分类的图像
testImage = imread('E:\大二下\智能船舶\十四十五周\第15课 图像处理及特征提取算法\CNN声图像分类程序\radon_trainset_weicai0\double\JX_1_110.jpg'); % 替换为要分类的图像路径

% 预处理图像（如调整大小）
inputSize = net_radon_sgdm2.Layers(1).InputSize; % 获取模型的输入大小
testImageResized = imresize(testImage, [inputSize(1) inputSize(2)]);

% 对图像进行分类
[label, scores] = classify(net_radon_sgdm2, testImageResized);

% 显示结果
figure;
imshow(testImage);
title(['Predicted: ' char(label) ' with confidence ' num2str(max(scores))]);
