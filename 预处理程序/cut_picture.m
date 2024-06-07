
%% 读取视频
video_file='E:\智能船舶lab2\数据组\三柱\MP4\20240521 100029 3Z Exported.mp4'; %%视频文件路径
video = VideoReader(video_file); %%创建VideoReader对象用于读取视频
frame_number = floor(video.Duration * video.FrameRate); %%计算视频的总帧数

%% 分割图片与打标签
step = 9; %%设置每隔几帧进行处理（此处默认为1，即每帧都进行处理）
n = 0; %%初始化计数器
for i = 1:step:frame_number 
    n = n + 1; %%逐帧增加计数器

    % 根据计数器的值确定图片的命名方式
    if n < 10
        image_name = strcat('E:\智能船舶lab2\数据组\三柱\CUT\image_000', num2str(n));
    elseif n >= 10 && n < 100
        image_name = strcat('E:\智能船舶lab2\数据组\三柱\CUT\image_00', num2str(n));
    elseif n >= 100 && n < 1000
        image_name = strcat('E:\智能船舶lab2\数据组\三柱\CUT\image_0', num2str(n));
    else 
        image_name = strcat('E:\智能船舶lab2\数据组\三柱\CUT\image_', num2str(n));
    end
    image_name = strcat(image_name, '.jpg'); %%图片保存路径及格式

    I = read(video, i);  %%读取当前帧的图像数据
    imwrite(I, image_name, 'jpg');  %%将图像数据保存为图片
    I = [];  %%清空图像数据，释放内存
end

