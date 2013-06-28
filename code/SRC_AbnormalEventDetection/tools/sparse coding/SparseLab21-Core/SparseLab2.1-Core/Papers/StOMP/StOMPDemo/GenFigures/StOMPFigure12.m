% Figure 12: Comparison of CS reconstruction of `Bumps' with 
% different algorithms.

N = 2^12;

x0 = MakeBumps(N)';
qmf = MakeONFilter('Symmlet',8); 

% Set finest, coarsest scales
j1 = 10;
j0 = floor(j1/2);

% Do Hybrid CS scheme
% Sample 2^j0 coarse-scale coeffs) at scale 2^(-j0)
alpha0 = FWT_PO(x0, j0, qmf);

alpha_Hybrid = zeros(size(alpha0));
alpha_Hybrid(1:2^j0) = alpha0(1:2^j0);
NHybrid = 2^j0;

% Construct a vector of wavelet coeffs at fine scales
theta = alpha0(setdiff(1:2^j1, 1:2^j0));
Mdetail = length(theta);
Ndetail = 608;
NHybrid = NHybrid + Ndetail;

% Generate Random Dictionary
A = MatrixEnsemble(Ndetail, Mdetail, 'USE');

% generate the vector S (random measurments of detail coeffs)
y = A * theta;

% Solve using BP (linear programming)
tic
alpha = SolveBP(A, y, Mdetail);
t_BP = toc;
alpha_Hybrid(setdiff(1:2^j1, 1:2^j0)) = alpha;
x_BP = IWT_PO(alpha_Hybrid, j0, qmf);

% Solve using OMP
tic
alpha = SolveOMP(A, y, Mdetail);
t_OMP = toc;
alpha_Hybrid(setdiff(1:2^j1, 1:2^j0)) = alpha;
x_OMP = IWT_PO(alpha_Hybrid, j0, qmf);

% Solve using ITSP with FDR thresholding
q = 0.5;
S = 10;
tic
[alpha, iters] = SolveStOMP(A, y, Mdetail, 'FDR', q, S, 1);
t_FDR = toc;
alpha_Hybrid(setdiff(1:2^j1, 1:2^j0)) = alpha;
x_FDR = IWT_PO(alpha_Hybrid, j0, qmf);

% Solve using ITSP with FDR thresholding
S = 10;
a_0 = (0.5*Ndetail/Mdetail)/S;
tic
[alpha, iters] = SolveStOMP(A, y, Mdetail, 'FAR', a_0, S, 1);
t_FAR = toc;
alpha_Hybrid(setdiff(1:2^j1, 1:2^j0)) = alpha;
x_FAR = IWT_PO(alpha_Hybrid, j0, qmf);

subplot(3,2,1:2); plot(x0); 
title(['(a) Signal Bumps, N = ' num2str(N)]);
axis([1 N 0 6]);

subplot(3,2,3); plot(x_BP); 
title(['(b) Hybrid CS with BP']);
axis([1 N 0 6]);

subplot(3,2,4); plot(x_OMP); 
title(['(c) Hybrid CS with OMP']);
axis([1 N 0 6]);

subplot(3,2,5); plot(x_FDR); 
title(['(d) Hybrid CS with CFDR thresholding']);
axis([1 N 0 6]);

subplot(3,2,6); plot(x_FAR); 
title(['(e) Hybrid CS with CFAR thresholding']);
axis([1 N 0 6]);

disp(['BP: ||x_hat-x||/||x|| = ' num2str(norm(x0-x_BP,'fro')./norm(x0,'fro'),3) ... 
    ', time = ' num2str(t_BP,2) ' secs']);
disp(['OMP: ||x_hat-x||/||x|| = ' num2str(norm(x0-x_OMP,'fro')./norm(x0,'fro'),3) ...  
    ', time = ' num2str(t_OMP,2) ' secs']);
disp(['FDR: ||x_hat-x||/||x|| = ' num2str(norm(x0-x_FDR,'fro')./norm(x0,'fro'),3) ... 
    ', time = ' num2str(t_FDR,2) ' secs']);
disp(['FAR: ||x_hat-x||/||x|| = ' num2str(norm(x0-x_FAR,'fro')./norm(x0,'fro'),3) ... 
    ', time = ' num2str(t_FAR,2) ' secs']);


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
