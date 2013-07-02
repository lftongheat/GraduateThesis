function [ energy, offset ] = computeSRenergy( Y, A, D, L, sc_algo )
%COMPUTESRENERGY Summary of this function goes here
%   Detailed explanation goes here

Nte = size(Y, 2);
Ntr = size(A, 2);

energy = zeros(Nte, 1);

% Compute the new representation of A as WA
WA = OMP(D, A, L);

% Compute the new representation of Y as WY
WY = OMP(D, Y, L);

% Compute the sparse representation X
Ainv = pinv(A);
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
    xpReduced = sparse_coding_methods(xInit(releventPosition), WA_reduced, w_y, sc_algo);
    
    xp(releventPosition)=xpReduced;
    
    %计算恢复后的值与初始猜测值的2范式即欧几里德范数 表示偏差或偏离度
    offset = norm(xp-xInit);
    
    %计算稀疏重建的能量值（根据能量计算公式： Energy = 1/2*norm(y-D*xp)*norm(y-D*xp) + lamda*norm(xp,1)）
    energy(i,:) = 1/2*norm(y-D*xp)*norm(y-D*xp) + norm(xp,1);
    
    
end

end

