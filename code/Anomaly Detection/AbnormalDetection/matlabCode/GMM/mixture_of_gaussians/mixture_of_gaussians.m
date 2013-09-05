
clear all

%source = aviread('Crowd-Activity-All.AVI'); %读入原始视频
source = VideoReader('viptraffic.avi'); %读入原始视频

% -----------------------获取视频规格大小-----------------------
%fr = source(1).cdata;           %读取第一帧
fr = read( source, 1);           %读取第一帧
fr_bw = rgb2gray(fr);           %转换为灰度图
fr_size = size(fr);             %获取视频大小
height = fr_size(1);
width = fr_size(2);
fg = zeros(height, width);      %前景
bg_bw = zeros(height, width);   %背景

% -----------------------设定高斯模型参数----------------------

C = 3;                                  % 混合高斯模型个数
M = 0;                                  % 背景高斯模型个数
D = 2.5;                                % 置信参数
alpha = 0.01;                           % 学习率（0-1之间）
thresh = 0.85;                          % 权值阈值
sd_init = 6;                            % 初始标准差
w = zeros(height,width,C);              % 权值矩阵
mean = zeros(height,width,C);           % 均值矩阵
sd = zeros(height,width,C);             % 标准差矩阵
u_diff = zeros(height,width,C);         % 差值矩阵
p = alpha/(1/C);                        % 参考学习率(alpha/w)
rank = zeros(1,C);                      % 优先级(w/sd)
B = 0;                                  %权值累加值


% ----------------------初始化高斯模型参数---------------------

pixel_depth = 8;                        % 8-bit resolution
pixel_range = 2^pixel_depth -1;         % pixel range (# of possible values)

for i=1:height
    for j=1:width
        for k=1:C
            
            mean(i,j,k) = rand*pixel_range;     % 初始化均值为255以内的随机值
            w(i,j,k) = 1/C;                     % 初始化权值为1/C（权值相同）
            sd(i,j,k) = sd_init;                % 初始化标准差为sd_init
            
        end
    end
end

%---------------------模型匹配以及参数更新---------------------

%for n = 1:length(source)
for n = 1:source.NumberOfFrames
    %fr = source(n).cdata;       % 读取帧
    fr = read(source , n);       % 读取帧
    fr_bw = rgb2gray(fr);       % 转换为灰度图
    
    %计算优先级并排序
    rank = w(i,j,:)./sd(i,j,:); % 优先级(w/sd) 
    temp = rank;                % 中间矩阵
    rank_ind = zeros(1,C);      % 优先级顺序矩阵
    %排序过程
    for k = 1:C
        [max_rank,max_rank_index] = max(temp);
        rank_ind(max_rank_index) = k;
        temp(max_rank_index) = 0;
    end
    
    % 计算差值矩阵，当前值与均值之差：diff=abs(I(x,y)-u)
    for m=1:C
        u_diff(:,:,m) = abs(double(fr_bw) - double(mean(:,:,m)));
    end
    
    % 更新高斯模型参数
    for i=1:height
        for j=1:width
            
            weight = w(i,j,:);     %记录初始权值，用于提取前景目标时的权值累加
            match = 0;             %设置匹配标志
            match_index = 0;       %设置匹配模型的位置
            for k=1:C                       
                if (abs(u_diff(i,j,k)) <= D*sd(i,j,k))   % 进行匹配
                    
                    match = 1;                           % 发生匹配
                    match_index = rank_ind(k);           % 匹配模型的位置
                    
                    % 更新匹配高斯模型的参数（w,p,u,sd)
                    w(i,j,k) = (1-alpha)*w(i,j,k) + alpha;
                    p = alpha/w(i,j,k);                  
                    mean(i,j,k) = (1-p)*mean(i,j,k) + p*double(fr_bw(i,j));
                    sd(i,j,k) =   sqrt((1-p)*(sd(i,j,k)^2) + p*((double(fr_bw(i,j)) - mean(i,j,k)))^2);
                    
                else                                    % 未匹配的高斯模型
                    w(i,j,k) = (1-alpha)*w(i,j,k);      % 仅更新权值(w减小)   
                end
            end
            
            % 没有发生匹配的高斯模型，则创建一个新的高斯模型代替权值最小的高斯模型
            if (match == 0)
                [min_w, min_w_index] = min(w(i,j,:));        %取权值最小的高斯模型 
                mean(i,j,min_w_index) = double(fr_bw(i,j));  %新高斯模型的均值取当前值
                sd(i,j,min_w_index) = sd_init;               
            end
 
            %计算权值累加值，匹配权值阈值thresh，并更新背景
            B = 0;            %权值累加值
            M = 0;           
            bg_bw(i,j)=0;     %背景
            temp = rank_ind;  %设置中间矩阵temp
            while  B<=thresh 
                    [max_rank_ind,max_rank_ind_index] = min(temp); %取最大优先级（序数最小）
                    B = B+weight(max_rank_ind_index);              %累加权值
                    bg_bw(i,j) = bg_bw(i,j)+ mean(i,j,max_rank_ind_index)*w(i,j,max_rank_ind_index); %更新背景
                    temp(max_rank_ind_index) = C+1;
            end
            M = max_rank_ind;
          
            
            
%------------------------提取前景目标-----------------------
            %提取前景
            k = 1;
            fg(i,j) = 0;
            while ((match == 0)&&(k<=M))                %与M个背景高斯模型进行匹配
                   index = 1;
                   while (rank_ind(index) ~= k)&&(index < C)
                       index = index+1;
                   end

                   if (abs(u_diff(i,j,index)) <= D*sd(i,j,index))
                       fg(i,j) = 0;    %匹配，则该点为背景点
                   else
                       fg(i,j) = 255;  %不匹配，该点为前景点   
                   end
         
                k = k+1;
            end
             
        end
    end
    

%     imshow(fg);
    figure(1)
    subplot(1,2,1),imshow(fr)
%     subplot(1,3,2),imshow(uint8(bg_bw)) 
    subplot(1,2,2),imshow(uint8(fg))     
    drawnow
    
    
 
    
%     Mov1(n)  = im2frame(uint8(fg),gray);           % put frames into movie
%     Mov2(n)  = im2frame(uint8(bg_bw),gray);           % put frames into movie
    
end
 
% movie2avi(Mov1,'mixture_of_gaussians_output','fps',30);           % save movie as avi 
% movie2avi(Mov2,'mixture_of_gaussians_background','fps',30);           % save movie as avi 
            

clear source;
 