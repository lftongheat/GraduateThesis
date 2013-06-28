% GenDataFig11: Creates the data file needed to generate figure 11: 
% Phase diagram for CFDR thresholding with noise at a specified 
% signal-to-noise ratio.
% 
function GenDataFig11(SNR)

ensemble = 'USE';
nonzeros = 'Gaussian';
N = 800;
T = 100;

fname = ['DataFig11-SNR' num2str(SNR) '.mat'];
myeps = 1e-4;
S = 10;
q = 0.5;

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
            % Here's how the noise variance is computed from the SNR:
            % Assume z_i ~ N(0,sigma^2), then E(||z||_2^2) = n*sigma^2.
            % In addition, E(||A*x||_2^2) = k, since A is drawn from 
            % the USE, and due to symmetry, the cross-terms have 
            % mean zero. 
            % Thus, SNR^2 = k / n*sigma^2, and sigma = sqrt(k/n) / SNR.
            
            z = (sqrt(k/n) ./ SNR) .* randn(n,1);
            y = A*x + z;

            % Solve the problem using CFDR
            [xhat, iters] = SolveStOMP(A, y, N, 'FDR', q, S);

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