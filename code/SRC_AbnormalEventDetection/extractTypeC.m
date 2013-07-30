%UCSD Ped1 Dataset 
%The training set contains 34 short chips for learning of normal patterns
%The testing set contains 10 clips provided with abnormal events
%Each clip has 200 frames with a 158*238 resolution

clear
%% Add path
addpath(genpath('tools/'));

%% Extract Features
rootdir = 'E:\Resources\vision_data\UCSD\UCSD_Anomaly_Dataset.v1p2\UCSDped1';
clip_num = 34;
traindir = [rootdir, '\Train'];
% train_hof = cell(34,1);
% for c=1:clip_num
%     disp(['clip', num2str(c)]);
%     if c<10
%         currentdir = [traindir, '\Train00', num2str(c)];
%     else
%         currentdir = [traindir, '\Train0', num2str(c)];
%     end
%     %获取文件夹下所有的文件
%     fileList = getAllFiles(currentdir);
%     %图片的数目
%     img_num = length(fileList);    
%     if img_num ==0;
%         error('设定的文件夹内没有任何的图片，请重新检查...')
%     end
%     
%     hofs = zeros(7*7*16,199);
%     pre = imread(fileList{1});
%     for ii = 2:img_num %开始遍历
%         imgname = fileList{ii};
%         cur = imread(imgname);
%         %imshow(cur);
%         %drawnow;
%         hof = computeHOF(pre, cur);
%         hofs(:,ii-1) = hof;
%         pre = cur;
%     end
%     train_hof{c,1} = hofs;
%     
% end

load data\ucsd_ped1_train_hof.mat;
train_basis = cell(5,5);
for i=1:5
    for j=1:5
        train_basis{i,j}=zeros(7*16,clip_num*197);
    end
end
%typeC Spatial-Temporal Basis
for c=1:clip_num
    hofs = train_hof{c,1};
    for f=3:199
       for pos=9:41 
           if mod(pos,7) == 0 || mod(pos-1,7) == 0
               continue;
           else
               left_pos = pos-1;
               right_pos = pos+1;
               up_pos = pos-7;
               down_pos = pos+7;
               curbasis = [hofs((pos-1)*16+1:pos*16,f); hofs((pos-1)*16+1:pos*16,f-1); hofs((pos-1)*16+1:pos*16,f-2)];
               leftbasis = hofs((left_pos-1)*16+1:left_pos*16,f);
               rightbasis = hofs((right_pos-1)*16+1:right_pos*16,f);
               upbasis = hofs((up_pos-1)*16+1:up_pos*16,f);
               downbasis = hofs((down_pos-1)*16+1:down_pos*16,f);
               spbasis = [curbasis; leftbasis; rightbasis; upbasis; downbasis];
               
               rownum = fix(pos/7);
               colnum = mod(pos,7)-1;
               train_basis{rownum,colnum}(:,(c-1)*197+(f-2)) = spbasis;
           end
       end
    end
end

% %load data\ucsd_ped1_train_basis.mat
% testdir = [rootdir, '\Test\Test014'];
% %获取文件夹下所有的文件
% fileList = getAllFiles(testdir);
% %图片的数目
% img_num = length(fileList);    
% if img_num ==0;
%     error('设定的文件夹内没有任何的图片，请重新检查...')
% end
% 
% test_hof = zeros(7*7*16,199);
% pre = imread(fileList{1});
% for i = 2:img_num %开始遍历
%     imgname = fileList{i};
%     cur = imread(imgname);
%     %imshow(img);
%     %drawnow;
% 
%     hof = computeHOF(pre, cur);
%     test_hof(:,i-1) = hof;
%     pre = cur;
% end
% 
% test_basis = cell(5,5);
% for i=1:5
%     for j=1:5
%         test_basis{i,j}=zeros(7*16,197);
%     end
% end
% for f=3:199
%    for pos=9:41 
%        if mod(pos,7) == 0 || mod(pos-1,7) == 0
%            continue;
%        else
%            left_pos = pos-1;
%            right_pos = pos+1;
%            up_pos = pos-7;
%            down_pos = pos+7;
%            curbasis = [test_hof((pos-1)*16+1:pos*16,f); test_hof((pos-1)*16+1:pos*16,f-1); test_hof((pos-1)*16+1:pos*16,f-2)];
%            leftbasis = test_hof((left_pos-1)*16+1:left_pos*16,f);
%            rightbasis = test_hof((right_pos-1)*16+1:right_pos*16,f);
%            upbasis = test_hof((up_pos-1)*16+1:up_pos*16,f);
%            downbasis = test_hof((down_pos-1)*16+1:down_pos*16,f);
%            spbasis = [curbasis; leftbasis; rightbasis; upbasis; downbasis];
% 
%            rownum = fix(pos/7);
%            colnum = mod(pos,7)-1;
%            test_basis{rownum,colnum}(:,f-2) = spbasis;
%        end
%    end
% end