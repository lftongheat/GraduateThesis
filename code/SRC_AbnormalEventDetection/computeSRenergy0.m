function [energy, avgTime] = computeSRenergy0(Y, A, D, sc_algo)
% ---------------------------------------------------
% Compute Sparse Representation Energy 
% Functionality: 
%       Find the approaximated sparse solution x of the linear system y=Ax
% Dimension: m  --- number of measurement
%            Nte--- number of testing samples
%            Ntr--- number of training samples
%
%                   Dimension          Description
% input:  Y          m x Nte       --- the testing sample
%         A          m x Ntr       --- the training sample
%         sc_algo                  --- the sparse coding algorithm
%                            e.g., l1magic, SparseLab, fast_sc, SL0, YALL1
% output: X          K x Nte       --- the sparse coefficient matrix of Y
%         avgTime                  --- average runtime for sparse coding
% 
% Reference: Jia-Bin Huang and Ming-Hsuan Yang, "Fast Sparse Representation with Prototypes.", the 23th IEEE Conference
%            on Computer Vision and Pattern Recognition (CVPR 10'), San Francisco, CA, USA, June 2010.
% Contact: For any questions, email me by jbhuang@ieee.org
% ---------------------------------------------------


Nte = size(Y, 2);
energy = zeros(Nte, 1);

%%
source = VideoReader('E:\Resources\vision_data\UMN Dataset\Crowd-Activity-All.AVI'); %读入原始视频
textColor    = [255, 0, 0]; % [red, green, blue]
textLocation = [50 50];       % [x y] coordinates
textInserter = vision.TextInserter('Warning!', ...
   'Color', textColor, 'FontSize', 24, 'Location', textLocation);


%% Compute the sparse representation X
Ainv = pinv(A);
sumTime=0;
for i = 1: Nte
    % Inital guess
    y = Y(:,i);
    xInit = Ainv * y;
    
    % sparse coding: solve a reduced linear system
    %disp(['sparse coding ...',num2str(i)]);
    tic
    xp = sparse_coding_methods(xInit, A, y, sc_algo);
    t = toc;
    sumTime = sumTime+t;
    
    %计算恢复后的值与初始猜测值的2范式即欧几里德范数 表示偏差或偏离度
    %offset(i,:) = norm(xp-xInit);
    
    %计算稀疏重建的能量值（根据能量计算公式： Energy = 1/2*norm(y-D*xp)*norm(y-D*xp) + lamda*norm(xp,1)）
    energy(i,1) = 1/2*norm(y-D*xp)*norm(y-D*xp) + norm(xp,1);
    disp(['frame', num2str(i), '    energy:', num2str(energy(i,1))]);
    
    %draw frame
    if i > 10
        fr = read(source , i);% 读取帧
        [energy] = smoothEnergy(energy);
        average = mean(energy(1:i,1))
        if energy(i) > 5*average
            J = step(textInserter, fr);
            imshow(J);
        else
            imshow(fr);
        end
        drawnow;
    end;
    
end
avgTime=sumTime/Nte;
clear source;
end