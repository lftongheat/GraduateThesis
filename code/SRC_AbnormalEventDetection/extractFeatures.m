%extract histogram of optical flow features from a video
%author: tong

clear all;

%read the test video from UNM video dataset
%scene1: 1    ---- 1450
%scene2: 1451 ---- 5595
%scene3: 5596 ---- 7739
source = VideoReader('E:\Resources\vision_data\UMN Dataset\Crowd-Activity-All.AVI'); %读入原始视频

%parameters
scene_start = 5596;
scene_end = 7739;
threshold = 0.8;
mlen = 4;   nlen = 5;
pre_frame = read(source, scene_start);%读取第1帧
pre_frame = rgb2gray(pre_frame);
frame_size = size(pre_frame);%row:240 col:320
region_height = frame_size(1)/mlen; %240/4=60
region_width = frame_size(2)/nlen; %320/5=64
HOFFeatures = zeros(mlen*nlen*16, scene_end - scene_start);

%extract hof
for k=scene_start+1:scene_end
    %if (mod(i-1,100) == 0)
    disp(['frames-----------',num2str(k)]);
    %end
    cur_frame = read(source, k);%读取帧
    cur_frame = rgb2gray(cur_frame);
    
    %%compute the features of optical flow by LK method
    [Vx,Vy] = opticalFlow(pre_frame,cur_frame,'smooth',1,'radius',10,'type','LK');%use piotr_toolbox
    [OFValue] = sqrt(Vx.*Vx+Vy.*Vy);%compute the speed
    OFAngle = zeros(frame_size);
    
    for i=1:frame_size(1)
        for j=1:frame_size(2)
            OFDegree = atan(Vy(i,j)/Vx(i,j));%compute the degree
            OFAngle(i,j) = OFDegree*180/pi;%convert to angle 得到的是-90到90度之间的值
            if (Vx(i,j)<0) %2 3 象限
                OFAngle(i,j) = OFAngle(i,j) +180;
            end
            if (Vx(i,j)>0 && Vy(i,j)<0) % 4象限
                OFAngle(i,j) = OFAngle(i,j) +360;
            end
        end
    end
    
    for m=1:mlen
        for n=1:nlen
            HOF = zeros(16,1);
            rowbegin = (m-1)*region_height+1;rowend = m*region_height;
            colbegin = (n-1)*region_width+1;colend = n*region_width;
            [regionVx] = Vx(rowbegin:rowend, colbegin:colend);
            [regionVy] = Vy(rowbegin:rowend, colbegin:colend);
            [regionValue] = OFValue(rowbegin:rowend, colbegin:colend);   
            [regionAngle] = OFAngle(rowbegin:rowend, colbegin:colend);    
            
            for i=1:region_height
                for j=1:region_width
                    angle = regionAngle(i,j);
                    value = regionValue(i,j);
                    if angle>=0 && angle<45
                        if value <= threshold
                            HOF(1) = HOF(1) + value;
                        else 
                            HOF(9) = HOF(9) + value;
                        end
                    elseif angle>=45 && angle<90
                        if value <= threshold
                            HOF(2) = HOF(2) + value;
                        else 
                            HOF(10) = HOF(10) + value;
                        end
                    elseif angle>=90 && angle<135
                        if value <= threshold
                            HOF(3) = HOF(3) + value;
                        else 
                            HOF(11) = HOF(11) + value;
                        end
                    elseif angle>=135 && angle<180
                        if value <= threshold
                            HOF(4) = HOF(4) + value;
                        else 
                            HOF(12) = HOF(12) + value;
                        end
                    elseif angle>=180 && angle<225
                        if value <= threshold
                            HOF(5) = HOF(5) + value;
                        else 
                            HOF(13) = HOF(13) + value;
                        end
                    elseif angle>=225 && angle<270
                        if value <= threshold
                            HOF(6) = HOF(6) + value;
                        else 
                            HOF(14) = HOF(14) + value;
                        end
                    elseif angle>=270 && angle<315
                        if value <= threshold
                            HOF(7) = HOF(7) + value;
                        else 
                            HOF(15) = HOF(15) + value;
                        end
                    else angle>=315 && angle<360;
                        if value <= threshold
                            HOF(8) = HOF(8) + value;
                        else 
                            HOF(16) = HOF(16) + value;
                        end
                    end
                end
            end
            
            startIndex = (m-1)*16*nlen + (n-1)*16 + 1;
            HOFFeatures(startIndex:startIndex+15,k-1) = HOF;
        end
    end    
    
    pre_frame=cur_frame;%update the pre_frame
end

save data\HOFFeatures_umn_scene3_0.8.mat HOFFeatures;