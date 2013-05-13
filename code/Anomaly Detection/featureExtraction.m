%extract optical flow features from a video
%author: tong 2013/3/31-2013/4/31

clear all;

%read the test video from UNM video dataset
source = VideoReader('E:\Resources\vision_data\PETS\59800-66750.avi'); %读入原始视频
%source = VideoReader('E:\Resources\vision_data\UMN Dataset\Crowd-Activity-All.AVI'); %读入原始视频
frame_len = source.NumberOfFrames;

mlen = 6;
nlen = 8;
%spMRF_features = cell(frame_len-1, 1);
pre_frame = read(source, 1);%读取第1帧
pre_frame = rgb2gray(pre_frame);
frame_size = size(pre_frame);%row:240 col:320 or 480*640
region_size = frame_size(1)/mlen; %40*40 or 80*80
subregion_size = frame_size(1)/mlen/2; %20*20 or 40*40
subregion_num = region_size/subregion_size;

mrf_features = cell(mlen, nlen);
for i=2:frame_len
    %if (mod(i-1,100) == 0)
        disp(['frames-----------',num2str(i-1)]);
    %end
    cur_frame = read(source, i);%读取帧
    cur_frame = rgb2gray(cur_frame);
    
    %%compute the features of optical flow by LK method
    %divide each frame to m*n regions and every region is also divided to u*v small sub-regions
    %compute the 9 dimension vector descriptor (8 orientations + 1 speed)
    %finally get 9uv dimension vector of each region(node)
    [Vx,Vy] = opticalFlow(pre_frame,cur_frame,'smooth',1,'radius',10,'type','LK');%use piotr_toolbox
    %show the visual result
%     figure
%     axis equal
%     quiver(impyramid(medfilt2(flipud(Vx), [5 5]), 'reduce'), -impyramid(medfilt2(flipud(Vy), [5 5]), 'reduce'));
    %划分出8个区域 分别对8个区域内点进行向量求和
%     [oreintation] = atan(Vy./Vx);%compute the orientation
%     [degree] = oreintation.*180/pi;%convert to degree
%     negIndex = find(Vx<0);%find the index of negtive elements in Vx for correct the degree in 2 or 3 quadrant(象限)
%     degree(negIndex) = degree(negIndex) + 180;
%     degree(:) = mod((degree(:)+360), 360);%change to 0-360 degree
    [speed] = sqrt(Vx.*Vx+Vy.*Vy);%compute the speed    
    
    for m=1:mlen
        for n=1:nlen
            %divide into regions 40*40 or 80*80
            rowbegin = (m-1)*region_size+1;rowend = m*region_size;
            colbegin = (n-1)*region_size+1;colend = n*region_size;
            [regionVx] = Vx(rowbegin:rowend, colbegin:colend);
            [regionVy] = Vy(rowbegin:rowend, colbegin:colend);
            [regionSpeed] = speed(rowbegin:rowend, colbegin:colend);
            
            nodeFeatures = cell(subregion_num,subregion_num);
            %divide into 4 sub-regions 20*20 or 40*40
            for u=1:subregion_num
                for v=1:subregion_num
                    rbegin = (u-1)*subregion_size+rowbegin;
                    cbegin = (v-1)*subregion_size+colbegin;
                    [subregionVx] = Vx(rbegin:rbegin+subregion_size-1, cbegin:cbegin+subregion_size-1);
                    [subregionVy] = Vy(rbegin:rbegin+subregion_size-1, cbegin:cbegin+subregion_size-1);
                    [subregionSpeed] = speed(rbegin:rbegin+subregion_size-1, cbegin:cbegin+subregion_size-1);
                    
                    speedSum = sum(subregionSpeed(:));%compute the sum of speed in sub-region
                    %divide sub-region into 8 patitions
                    quadrant = cell(2, 8);
                    %Vx
                    [quadrant1x]=subregionVx(1:subregion_size/2, subregion_size/2+1:subregion_size);%partition 0-90 degree , first quadrant
                    quadrant{1,1} = tril(fliplr(quadrant1x));%次对角线的下三角 需先进行翻转
                    quadrant{1,2} = triu(fliplr(quadrant1x));%次对角线的上三角 需先进行翻转                 
                    [quadrant2x]=subregionVx(1:subregion_size/2, 1:subregion_size/2);%partition 90-180 degree , second quadrant
                    quadrant{1,3} = triu(quadrant2x);%主对角线的上三角
                    quadrant{1,4} = tril(quadrant2x);%主对角线的下三角
                    [quadrant3x]=subregionVx( subregion_size/2+1:subregion_size, 1:subregion_size/2);%partition 180-270 degree , third quadrant
                    quadrant{1,5} = triu(fliplr(quadrant3x));%次对角线的上三角 需先进行翻转
                    quadrant{1,6} = tril(fliplr(quadrant3x));%次对角线的下三角
                    [quadrant4x]=subregionVx( subregion_size/2+1:subregion_size,  subregion_size/2+1:subregion_size);%partition 270-360 degree , fourth quadrant
                    quadrant{1,7} = tril(quadrant4x);
                    quadrant{1,8} = triu(quadrant4x);
                    %Vy
                    [quadrant1y]=subregionVy(1:subregion_size/2,  subregion_size/2+1:subregion_size);%partition 0-90 degree , first quadrant
                    quadrant{2,1} = tril(fliplr(quadrant1y));%次对角线的下三角 需先进行翻转
                    quadrant{2,2} = triu(fliplr(quadrant1y));%次对角线的上三角 需先进行翻转                   
                    [quadrant2y]=subregionVy(1:subregion_size/2, 1:subregion_size/2);%partition 90-180 degree , second quadrant
                    quadrant{2,3} = triu(quadrant2y);%主对角线的上三角
                    quadrant{2,4} = tril(quadrant2y);%主对角线的下三角
                    [quadrant3y]=subregionVy( subregion_size/2+1:subregion_size, 1:subregion_size/2);%partition 180-270 degree , third quadrant
                    quadrant{2,5} = triu(fliplr(quadrant3y));%次对角线的上三角 需先进行翻转
                    quadrant{2,6} = tril(fliplr(quadrant3y));%次对角线的下三角
                    [quadrant4y]=subregionVy( subregion_size/2+1:subregion_size,  subregion_size/2+1:subregion_size);%partition 270-360 degree , fourth quadrant
                    quadrant{2,7} = tril(quadrant4y);
                    quadrant{2,8} = triu(quadrant4y);
                    
                    [oreintations] = zeros(1,8);
                    %求8个划分的向量和
                    for k=1:8
                        vectorY = sum(quadrant{2,k}(:));
                        vectorX = sum(quadrant{1,k}(:));
                        degree = atan(vectorY/vectorX);%compute the orientation
                        angle = degree.*180/pi;%convert to angle 得到的是-90到90度之间的值
                        if (vectorX<0) %2 3 象限
                            angle = angle +180;
                        end
                        if (vectorX>0 && vectorY<0) % 4象限
                            angle = angle +360;
                        end
                        oreintations(k) = angle;
                    end
                    nodeFeatures{u,v} = [speedSum, oreintations];
                end
            end
            nodeFeatures = [nodeFeatures{1,1},nodeFeatures{1,2},nodeFeatures{2,1},nodeFeatures{2,2}];
            mrf_features{m,n}(i-1,:) = nodeFeatures;
        end
    end    
    
    %spMRF_features{i-1,1} = mrf_features;
    %%end fo computing features
    pre_frame=cur_frame;%update the pre_frame
end

save OpticalFlowFeatures_pets.mat mrf_features;