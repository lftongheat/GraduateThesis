function [energyReduce, avgTime] = computeSRenergy( Y, A, D, L, sc_algo )
% ---------------------------------------------------
% Compute Sparse Representation Energy using Fast Sparse Representation with Prototypes
% Functionality: 
%       Find the approaximated sparse solution x of the linear system y=Ax
% Dimension: m  --- number of measurement
%            Nte--- number of testing samples
%            Ntr--- number of training samples
%
%                   Dimension          Description
% input:  Y          m x Nte       --- the testing sample
%         A          m x Ntr       --- the training sample
%         D          m x K         --- the learned dictionary
%         L                        --- the number of atoms in OMP
%         sc_algo                  --- the sparse coding algorithm
%                            e.g., l1magic, SparseLab, fast_sc, SL0, YALL1
% output: X          K x Nte       --- the sparse coefficient matrix of Y
%         accuracy                 --- accuracy of the classification task
%         avgTime                  --- average runtime for sparse coding
% 
% Reference: Jia-Bin Huang and Ming-Hsuan Yang, "Fast Sparse Representation with Prototypes.", the 23th IEEE Conference
%            on Computer Vision and Pattern Recognition (CVPR 10'), San Francisco, CA, USA, June 2010.
% Contact: For any questions, email me by jbhuang@ieee.org
% ---------------------------------------------------

%%
source = VideoReader('E:\Resources\vision_data\UMN Dataset\Crowd-Activity-All.AVI'); %读入原始视频
textColor    = [255, 0, 0]; % [red, green, blue]
textLocation = [50 50];       % [x y] coordinates
textInserter = vision.TextInserter('Warning!', ...
   'Color', textColor, 'FontSize', 24, 'Location', textLocation);
%%
Nte = size(Y, 2);
Ntr = size(A, 2);

energyReduce = zeros(Nte, 1);

% Compute the new representation of A as WA （A是训练集）
WA = OMP(D, A, L);

% Compute the new representation of Y as WY （Y是测试集）
WY = OMP(D, Y, L);

% Compute the sparse representation X
Ainv = pinv(A);
sumTime=0;
for i = 1: Nte
    % Inital guess
    y = Y(:,i);
    xInit = Ainv * y;
    xp = zeros(Ntr,1);
    
    % new representation of the test sample y
    w_y = WY(:,i);
    
    % keep columns with a least one overlapped support and dicard the rest
    [WA_reduced, releventPosition] = reduceMatrix(w_y, WA);
    
    % sparse coding: solve a reduced linear system
    tic
    xpReduced = sparse_coding_methods(xInit(releventPosition), WA_reduced, w_y, sc_algo);
    t = toc;
    sumTime = sumTime+t;
    
    xp(releventPosition)=xpReduced;    
    
    %计算稀疏重建的能量值（根据能量计算公式： Energy = 1/2*norm(y-D*xp)*norm(y-D*xp) + lamda*norm(xp,1)）
    %energy(i,:) = 1/2*norm(y-D*xInit)*norm(y-D*xInit) + norm(xInit,1);
    
    energyReduce(i,:) = 1/2*norm(w_y-WA_reduced*xpReduced)*norm(w_y-WA_reduced*xpReduced) + norm(xpReduced,1);
    
    disp(['frame', num2str(i), '    energyReduce:', num2str(energyReduce(i,:))]);
	
    %draw frame
    if i > 10
        fr = read(source , i);% 读取帧
        [energyReduce] = smoothEnergy(energyReduce);
        average = mean(energyReduce(1:i,1))
        if energyReduce(i) > 5*average
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

