% GenDataTbl01: Generates the data that appears in Table 1:
% Comparison of running times on a random problem suite, for BP,OMP,FDR,FAR.

rand('state',4159487393);
randn('state',6504972169);

NArr = [1000, 1000, 10000, 10000];
nArr = [100,  500,  1000,  2500];
kArr = [10,   100,  100,   500];

tBP = zeros(size(NArr));
tOMP = zeros(size(NArr));
tFDR = zeros(size(NArr));
tFAR = zeros(size(NArr));
eBP = zeros(size(NArr));
eOMP = zeros(size(NArr));
eFDR = zeros(size(NArr));
eFAR = zeros(size(NArr));

for ii = 1:length(NArr)
    ii
    n = nArr(ii);
    N = NArr(ii);
    k = kArr(ii);
    
    x = SparseVector(N,k,'Gaussian',1);
    A = MatrixEnsemble(n,N);
    y = A*x;

    % Initialize threshold parameters
    delta = n/N;
    rho = k/n;
    S = 10;
    alpha_0 = delta*(1-rho)/S;
    q = min((n-k)/k,0.5);

    % Solve using BP (via PDCO)
    tic
    xBP = SolveBP(A, y, N);
    tBP(ii) = toc;
    eBP(ii) = norm(xBP - x);

    % Solve with OMP
    tic
    [xOMP, iters, activeSet] = SolveOMP(A, y, N);
    tOMP(ii) = toc;
    eOMP(ii) = norm(xOMP - x);
    
    % Solve with FDR thresholding
    tic
    [xFDR, iters] = SolveStOMP(A, y, N, 'FDR', q, S, 1);
    tFDR(ii) = toc;
    eFDR(ii) = norm(xFDR - x);
    
    % Solve with FAR thresholding
    tic
    [xFAR, iters] = SolveStOMP(A, y, N, 'FAR', alpha_0, S, 1);
    tFAR(ii) = toc;
    eFAR(ii) = norm(xFAR - x);
end

save DataTbl01.mat NArr nArr kArr tBP tOMP tFDR tFAR eBP eOMP eFDR eFAR


%
% Copyright (c) 2006. David Donoho, Iddo Drori, and Yaakov Tsaig
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%