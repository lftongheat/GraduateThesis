%--------------------------------------------------------------
% Hybrid CS reconstruction of "random-bars" with BP,FDR,FAR,BCS
% This code generates Figure 6 of the following paper: 
% "Bayesian Compressive Sensing" (Preprint, 2007).
% This example is modified from one example of Sparselab.
% The original example only tests the performance of BP. 
% We here add FDR, FAR and BCS. 
% Modified by: Shihao Ji, ECE, Duke University
% last change: Jan. 2, 2007
%--------------------------------------------------------------
clear all;
load I0.mat
%
n = 1024; % image size
qmf = MakeONFilter('Haar',1); 

% Set finest, coarsest scales
j1 = 6;
j0 = ceil(j1/2);
c = 0.5;
% First, linear sampling by measuring 4^j1 coeffs
% (of scaling functions on scale 2^(-j1) x 2^(-j1)
alpha0 = FWT2_PO(I0, j0, qmf);
alpha_LIN = zeros(size(alpha0));
alpha_LIN(1:2^j1,1:2^j1) = alpha0(1:2^j1,1:2^j1);

% Now, do Hybrid CS scheme
% Sample 4^j0 resume coefficients (coarse-scale 
% coeffs) at scale 2^(-j0) x 2^(-j0)
alpha_BP = zeros(size(alpha0));
alpha_BP(1:2^j0,1:2^j0) = alpha0(1:2^j0,1:2^j0);
alpha_FDR = alpha_BP;
alpha_FAR = alpha_BP;
alpha_BCS = alpha_BP;

% Construct the vector theta of detail wavelet 
% coeffs on scales j0 <= j < j1
theta1 = alpha0((2^j0+1):2^j1,1:2^j0);
theta2 = alpha0(1:2^j1,(2^j0+1):2^j1);
n1 = prod(size(theta1));
n2 = prod(size(theta2));
theta = [theta1(:); theta2(:)];

Mdetail = 4^j1 - 4^j0;
Ndetail = floor(c * j1^2 * 4^j0);

% Generate Random Dictionary
Pstate = 4972169;
randn('state',Pstate);
Phi = MatrixEnsemble(Ndetail, Mdetail, 'USE');

% generate the vector S (random measurments of detail coeffs)
S = Phi * theta;

% Solve using BP
tic;
alpha = SolveBP(Phi, S, Mdetail, 100, 0, 1e-6);
t_BP = toc;
fprintf(1,'BP number of nonzero weights: %d\n',sum(alpha~=0));
alpha_BP((2^j0+1):2^j1,1:2^j0) = reshape(alpha(1:n1), 2^j1-2^j0, 2^j0);
alpha_BP(1:2^j1,(2^j0+1):2^j1) = reshape(alpha(n1+1:n1+n2), 2^j1, 2^j1-2^j0);

% Solve using ITSP with FDR thresholding
q = 0.9;
tic;
[alpha, iters] = SolveStOMP(Phi, S, Mdetail, 'FDR', q, 30, 1);
t_FDR = toc;
alpha_FDR((2^j0+1):2^j1,1:2^j0) = reshape(alpha(1:n1), 2^j1-2^j0, 2^j0);
alpha_FDR(1:2^j1,(2^j0+1):2^j1) = reshape(alpha(n1+1:n1+n2), 2^j1, 2^j1-2^j0);

% Solve using ITSP with FAR thresholding
a_0 = (0.5*Ndetail/Mdetail)/30;
tic;
[alpha, iters] = SolveStOMP(Phi, S, Mdetail, 'FAR', a_0, 30, 1);
t_FAR = toc;
alpha_FAR((2^j0+1):2^j1,1:2^j0) = reshape(alpha(1:n1), 2^j1-2^j0, 2^j0);
alpha_FAR(1:2^j1,(2^j0+1):2^j1) = reshape(alpha(n1+1:n1+n2), 2^j1, 2^j1-2^j0);

% Solve using BCS
initsigma2 = std(S)^2/1e6;
tic;
[weights,used] = BCS_fast_rvm(Phi,S,initsigma2,1e-8);
t_BCS = toc;
alpha = zeros(Mdetail,1);
alpha(used) = weights;
fprintf(1,'BCS number of nonzero weights: %d\n',length(used));
alpha_BCS((2^j0+1):2^j1,1:2^j0) = reshape(alpha(1:n1), 2^j1-2^j0, 2^j0);
alpha_BCS(1:2^j1,(2^j0+1):2^j1) = reshape(alpha(n1+1:n1+n2), 2^j1, 2^j1-2^j0);

% Reconstruct
I_LIN = IWT2_PO(alpha_LIN, j0, qmf);
I_BP =  IWT2_PO(alpha_BP,  j0, qmf);
I_FDR = IWT2_PO(alpha_FDR, j0, qmf);
I_FAR = IWT2_PO(alpha_FAR, j0, qmf);
I_BCS = IWT2_PO(alpha_BCS, j0, qmf);
% compute error
E_LIN = twonorm(I0 - I_LIN) / twonorm(I0);
E_BP  = twonorm(I0 - I_BP ) / twonorm(I0);
E_FDR = twonorm(I0 - I_FDR) / twonorm(I0);
E_FAR = twonorm(I0 - I_FAR) / twonorm(I0);
E_BCS = twonorm(I0 - I_BCS) / twonorm(I0);


subplot(2,2,1); AutoImage(I_LIN); title(['(a) Linear Reconstruction, K=' num2str(4^j1)]);
subplot(2,2,2); AutoImage(I_FDR); title(['(b) Hybrid CS with CFDR, K=' num2str(Ndetail+4^j0)]);
subplot(2,2,3); AutoImage(I_FAR); title(['(c) Hybrid CS with CFAR, K=' num2str(Ndetail+4^j0)]);
subplot(2,2,4); AutoImage(I_BCS); title(['(d) Hybrid CS with BCS, K=' num2str(Ndetail+4^j0)]);

disp(['LIN: ||I_hat-I||/||I|| = ' num2str(E_LIN)]);
disp(['BP:  ||I_hat-I||/||I|| = ' num2str(E_BP) ',  time = ' num2str(t_BP) ' secs']);
disp(['FDR: ||I_hat-I||/||I|| = ' num2str(E_FDR) ', time = ' num2str(t_FDR) ' secs']);
disp(['FAR: ||I_hat-I||/||I|| = ' num2str(E_FAR) ', time = ' num2str(t_FAR) ' secs']);
disp(['BCS: ||I_hat-I||/||I|| = ' num2str(E_BCS) ', time = ' num2str(t_BCS) ' secs']);

save bar_results.mat I0 I_LIN I_BP I_FDR I_FAR I_BCS E_LIN E_BP E_FDR E_FAR E_BCS t_BP t_FDR t_FAR t_BCS ...
    Ndetail Mdetail alpha_LIN alpha_BP alpha_FDR alpha_FAR alpha_BCS j0 j1;
disp('Done!');