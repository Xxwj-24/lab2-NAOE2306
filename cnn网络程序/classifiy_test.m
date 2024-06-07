clear all
close all
clc
%以下取消注释，改好路径可运行，程序运行很慢
%%程序分为两部分，注释掉的部分是数据增量部分，通过旋转、滤波、翻转、平移等操作增加样本量，形成数据集。
%%这部分学生可以自行选取方法增量图片数据。
%%第二部分，以第一部分形成数据集为基础，随机选取70%做为训练样本，剩余30%做为测试样本。
%%构建CNN卷积网络，主要设置网络各层，和设置网络一些参数。

% % % radon图片集并训练
% % 进行数据增量及radon变换并训练
% filename = string();
% filename(1)='单柱顺转1-1';
% filename(2)='双柱顺转1-1';
% filename(3)='三柱顺转1-1';
% filename(4)='四柱顺转1-1';
% filename(5)='T型顺转1-1';
% outname = string();
% outname(1)='single';
% outname(2)='double';
% outname(3)='triple';
% outname(4)='quadruple';
% outname(5)='T-shape';
% outfilename1 = 'xiaozengliang';
% for filenum = 1:length(filename)
% pathname = strcat('E:\教学\本科课程\2023春季智能船舶基础\4特征识别\材料\images_train_5s\',filename(filenum),'\*.jpg');
% path1 = dir(pathname);
% img_dir = sort_nat({path1.name});       
% [~,n] = size(img_dir);
% targetsize=[400 400];%选取图片像素，长400，宽400   
% jiange =10;
% 
% %%%%%%%%%%%%%旋转变换%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for i = 1:n  %n是现有每类图片的n张，可由图像分割程序获得
% %     
%     n
%       picture_str= strcat('E:\教学\本科课程\2023春季智能船舶基础\4特征识别\材料\images_train_5s\',filename(filenum),'\', img_dir{1,i}) ;
%       data=(rgb2gray(imread(picture_str)));    
%       crop_region=centerCropWindow2d(size(data),targetsize);
%       cropdata2=imcrop(data,crop_region);
% 
% for j=1:(360/jiange)   %radon变换角度设置
%     j
% rdata = imrotate(cropdata2,-jiange*j,'bilinear','crop');   % 旋转  "-" 顺时针  + 逆时针
% theta = 0:360;             % 间隔5
% [R,xp] = radon(rdata,theta);
% h = figure;
% imshow(R,[],'InitialMagnification','fit','border','tight')   % []:根据R的像素值的范围缩放显示
% colormap(gca,jet)
% axis normal
% savepic=strcat('E:\教学\本科课程\2023春季智能船舶基础\4特征识别\材料\',...
%     outfilename1,'\',outname(filenum),'\XZ_',num2str(i),'_',num2str(j*jiange),'.jpg');
% saveas(h,savepic)
% close all
% %%%%%%%%%%%%%中值滤波去噪%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % medfilt2
% M1 = medfilt2(rdata);
% theta = 0:360;            
% [R,xp] = radon(M1,theta);
% h = figure;
% imshow(R,[],'InitialMagnification','fit','border','tight')   
% colormap(gca,jet)
% axis normal
% savepic=strcat('E:\教学\本科课程\2023春季智能船舶基础\4特征识别\材料\',...
%     outfilename1,'\',outname(filenum),'\lvbo_',num2str(i),'_',num2str(j*jiange),'.jpg');
% saveas(h,savepic)
% close all
% %%%%%%%%%%%%%%图像翻转%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% JX2 = flip(M1,2);    
% theta = 0:360;            
% [R,xp] = radon(JX2,theta);
% h = figure;
% imshow(R,[],'InitialMagnification','fit','border','tight')   
% colormap(gca,jet)
% axis normal
% savepic=strcat('E:\教学\本科课程\2023春季智能船舶基础\4特征识别\材料\',...
%     outfilename1,'\',outname(filenum),'\JX_',num2str(i),'_',num2str(j*jiange),'.jpg');
% saveas(h,savepic)
% close all
% %%%%%%%%%%%%%%图像平移%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PY2 = imtranslate(rdata,[10, 10],'bilinear','FillValues',0);   
% [R,xp] = radon(PY2,theta);
% h = figure;
% imshow(R,[],'InitialMagnification','fit','border','tight')  
% colormap(gca,jet)
% axis normal
% savepic=strcat('E:\教学\本科课程\2023春季智能船舶基础\4特征识别\材料\',...
%     outfilename1,'\',outname(filenum),'\PY_',num2str(i),'_',num2str(j*jiange),'.jpg');
% saveas(h,savepic)
% 
% end 
% end
% filenum
% end

% 搭建网络训练
timevalue_huidu = tic;   
loadtrainset ='radon_trainset_weicai';
digitDatasetPath = strcat('E:\大二下\智能船舶\十四十五周\第15课 图像处理及特征提取算法\CNN声图像分类程序\',loadtrainset);                
imds1 = imageDatastore(digitDatasetPath,'IncludeSubfolders',true, 'LabelSource','foldernames');
numTrainFiles = 0.7;           
[imdsTrain1,imdsValidation1] = splitEachLabel(imds1,numTrainFiles,'randomize'); %%将图片集70%分配训练样本，30%做为测试样本    
imdstrain1count_huidu = countEachLabel(imdsTrain1);
imdsvalidation1count_huidu = countEachLabel(imdsValidation1);
filedir=dir(strcat('E:\大二下\智能船舶\十四十五周\第15课 图像处理及特征提取算法\CNN声图像分类程序\',loadtrainset,'\','single\*.jpg'));
filedir1 = sort_nat({filedir.name});
loadpath_r = strcat('E:\大二下\智能船舶\十四十五周\第15课 图像处理及特征提取算法\CNN声图像分类程序\',loadtrainset,'\single\',filedir1{1,1});
picture_s = imread(loadpath_r);
numRows= size(picture_s,1);
numCols= size(picture_s,2);
inputSize = [numRows numCols 3];   %%确定图片的输入大小和通道
% 在卷积神经网络（CNN）中，图像输入参数的长和宽通常指的是输入图像的像素数，即输入图像的大小。在使用CNN进行图像分类或图像处理时，
% 通常需要将输入图像的大小调整为固定的大小，以便于网络的处理。对于一个RGB彩色图像，其大小通常表示为（长，宽，通道数），其中通道数为3，
% 分别表示红、绿、蓝三个通道。数字数据由灰度图像组成，因此通道大小（颜色通道）为 1。
numClasses = 5;   %% 5类目标                     

layers = [
    imageInputLayer(inputSize)  %%输入层 
%%%%%%%%%%%%%%%%%%%%%%%%%以下层数设计和参数设计可以自行调整%%%%%%%%%%%%%%%%%%%%%
    convolution2dLayer(5,16,'Padding','same','Stride',2)    % 搭建卷积网络第一层
    batchNormalizationLayer                                 %%批量归一化层
    reluLayer                                               %% 整流线性单元(ReLU)层，也叫正则化层
    maxPooling2dLayer(2,'Stride',2)                         %% 二维最大池化层，使用的是最大值池化

    convolution2dLayer(5,32,'Padding','same','Stride',2)     % 搭建卷积网络第二层
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,64,'Padding','same','Stride',1)     % 搭建卷积网络第三层
    batchNormalizationLayer
    reluLayer   
    maxPooling2dLayer(2,'Stride',2) 
    
    convolution2dLayer(3,128,'Padding','same','Stride',1)     % 搭建卷积网络第四层
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(2,'Stride',2)

    convolution2dLayer(3,256,'Padding','same','Stride',1)     % 搭建卷积网络第五层
    batchNormalizationLayer
    reluLayer

    fullyConnectedLayer(numClasses)       %%%全连接层，将池化后的能量进行全链接计算，把结果给输出层
    softmaxLayer
    classificationLayer];

%trainingOptions用于设置神经网络的训练策略以及超参数
options = trainingOptions('adam', ...      %优化函数，可选’sgdm’，‘rmsprop’，‘adam’
    'InitialLearnRate',0.001, ...          %初始学习率
    'MaxEpochs',8, ...                    %最大训练回合数，正整数，默认为20
    'Shuffle','every-epoch', ...           Shuffle：数据打乱策略，可选,once,，‘never’，‘every-epoch’,‘once’：在训练前打乱,‘never’：不打乱‘every-epoch’：每个epoch打乱一次
    'MiniBatchSize',128, ...                %batchsize,每次迭代使用的数据量，正整数
    'ValidationData',imdsValidation1, ...  %验证集数据，imdsValidation1
    'ValidationFrequency',5, ...           %验证频率，几个batchsize后验证一次
    'ExecutionEnvironment','auto', ...     %硬件环境，用GPU还是CPU，可选 auto’，‘cpu’，‘gpu’，‘multi-gpu’，'auto’为有gpu则用，没有就用cpu
    'Verbose',true, ...                    % 命令窗口显示训练过程的指令是否在命令行窗口显示实时训练进程，0或1，若为1，则在命令行显示当前在干啥了，默认为true
    'VerboseFrequency',10, ...             % Verbose在命令行打印的频率，默认为10
    'LearnRateSchedule','piecewise', ...   %学习率策略，%none 或者’piecewise’，'none’表示学习率不变，'piecewise’为分段学习率
    'LearnRateDropPeriod',5, ...          %学习率下降周期，即几个epoch下降一次学习率
    'LearnRateDropFactor',0.5, ...         %学习率下降因子，[0,1]之间，降低之后学习率为：当前学习率*下降因子
    'Plots','training-progress');



net_radon_sgdm2 = trainNetwork(imdsTrain1,layers,options);%为图像分类问题训练网络。图像数据存储区 imds存储输入的图像数据， layers定义网络体系结构，并 options定义训练选项。
save net_radon0427_sgdm2

toc(timevalue_huidu)                        %% 显示总的计算时间