%%
% 功能：程序实现了将多幅图片转换为AVI格式
% 说明：1.可以选择是否对图片进行预处理，如果图片都是尺寸相同，图片格式相同，
%         那么可以直接跳过这一步,否则对图片进行预处理操作
%       2.步骤：
%          step1: 参数设置
%          step2: 遍历目标文件夹下的所有图片,将图片的路径信息保存为结构体
%          step3: 按照设定的参数读取图片，并进行预处理操作
%          step4: 得到图片信息,转化为AVI,并进行保存


%% step1:参数的设置

clear 
clc
disp('第一步，基本参数的设置...................')

%待处理图片的存放文件夹，可以存在子文件夹的情况
dirName = 'D:\GitHub\GraduateThesis\Optical Flow\DATA';

%处理后的文件夹的存放位置，可以不存在，程序会自动生成
desName = 'D:\GitHub\GraduateThesis\Optical Flow\PDATA';

%最终图片的归一化尺寸
thesizex = 500;thesizey=500; thesizez=3; ischangeszie = 0;

%采用RGB还是直接使用Gray的图片
imagetype = 'RGB';

%图片的通用格式设置
fmt = '.bmp';

%% step2:遍历目标文件夹下的所有图片,将图片的路径信息保存为结构体
disp('第二步，获取文件夹下所有的图像文件...................')

%注意：不要在此文件夹下放其他类型的文件，否则会报错
%获取文件夹下所有的文件
fileList = getAllFiles(dirName);

%% step3: 开始对图片进行预处理操作
disp('第三步，开始对对每一张图片进行处理...................')

%图片的数目
img_num = length(fileList);

if img_num ==0;
    error('设定的文件夹内没有任何的图片，请重新检查...')
end

for ii = 1:img_num %开始遍历
    imgname = fileList{ii};
    I_img = imread(imgname);
    
    %转化为灰度图
    [sizex,sizey,sizez] = size(I_img);
    if sizez ==3&&strcmp(imagetype,'Gray')
        I_img = rgb2gray(I_img);
        thesizez = 1;
    end
    
    if ii==1
        disp(strcat('当前尺寸范围为: ',num2str(sizex),' *',num2str(sizey),';\n'));
    elseif (ii==1)&&(ischangeszie==1)
        disp(strcat('现将所有图片转化为：',num2str(thesizex),'*',num2str(thesizey)));
        ischange = input('是否对变换尺寸进行更改：是(1) 否(0)');
        if ischange ==1
            thesizex = input('请输入归一化图像的高度：');
            thesizey = input('请输入归一化图像的宽度：');
        end
    elseif (ii==1)&&(ischangeszie==0)
        disp('不进行图像的尺寸变换');
    end
    
    %进行尺寸的归一化操作
    if ischangeszie==1
        I_img = imresize(I_img,[thesizex,thesizey],'bilinear');
    end
    
    %对处理的图片进行统一命名的保存
    if ii==1
        if not(exist(desName,'dir'))
            mkdir(desName);
        end
    end
    imwrite(I_img,strcat(desName,'\',num2str(ii),fmt),fmt(2:end));
end
clear ii I_img sizex sizey sizez fileList 

%% step4: 得到图片信息,转化为AVI,并进行保存

%获取文件夹下所有的文件
fileList = getAllFiles(desName);

%图片的数目
img_num_out = length(fileList);

if img_num_out ==0|| img_num_out~=img_num
    error('设定的文件夹内的图片数量出现了错误，请重新检查...')
end

%创建一个AVI格式的容器,用于保存图像数据信息
aviobj = avifile('oftest.avi','fps',1);

%Mdata = zeros(thesizex,thesizey,thesizez,img_num_out,'uint8');
for i=1:img_num_out
    %Mdata(:,:,:,i)=imread(fileList{i});
    Mdata = imread(fileList{i});
    imshow(Mdata)
    frame = getframe(gca);
    aviobj = addframe(aviobj,frame);
end
aviobj = close(aviobj);

