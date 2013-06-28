% GenDataFig06: Creates the data file needed to generate figure 6: 
% Phase diagram for CFAR thresholding. 

ensemble = 'USE';
nonzeros = 'Gaussian';
N = 800;
T = 100;

fname = 'DataFig06.mat';
myeps = 1e-4;
S = 10;

deltaLen = 50;
rhoLen = 50;
deltaArr = linspace(0.05,1,deltaLen);
rhoArr = linspace(0.05,1,rhoLen);

ErrVecL2 = zeros(length(deltaArr), length(rhoArr), T);
ErrVecL0 = zeros(length(deltaArr), length(rhoArr), T);

tstart = 1;
if (exist(fname))
    load(fname);
    tstart = ti+1;
end

for ti = tstart:T
    for ni = 1:length(deltaArr)
        n = floor(N.*deltaArr(ni));
        for ki = 1:length(rhoArr)
            k = ceil(rhoArr(ki) .* n);
            disp(['n = ' num2str(n) ', k = ' num2str(k) ', #' num2str(ti)]);

            A = MatrixEnsemble(n,N,ensemble);
            x = SparseVector(N,k,nonzeros,1);
            y = A*x;

            a_0 = (0.5*deltaArr(ni))/S;

            % Solve the problem using CFAR
            [xhat, iters] = SolveStOMP(A, y, N, 'FAR', a_0, S);

            ErrVecL2(ni,ki,ti) = norm(x - xhat) ./ norm(x);
            ErrVecL0(ni,ki,ti) = length(find(abs(x - xhat) > myeps)) ./ length(find(abs(x) > myeps));
        end
    end
    save(fname, 'ErrVecL0', 'ErrVecL2', 'deltaArr', 'deltaLen', 'rhoArr', 'rhoLen', 'N', 'ensemble', 'nonzeros', 'T', 'ti');
end

muErrVecL0 = mean(ErrVecL0,3);
muErrVecL2 = mean(ErrVecL2,3);
save(fname, 'muErrVecL0', 'muErrVecL2', 'deltaArr', 'deltaLen', 'rhoArr', 'rhoLen', 'N', 'ensemble', 'nonzeros', 'T', 'ti');

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
