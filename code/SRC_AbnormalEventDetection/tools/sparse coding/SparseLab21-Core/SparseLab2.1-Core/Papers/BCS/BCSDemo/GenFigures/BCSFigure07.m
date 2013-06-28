%---------------------------------------------------------
% Multiscale CS reconstruction of a Mondrian painting with
% BP,FDR,FAR,BCS
% This code generates Figure 7 of the following paper: 
% "Bayesian Compressive Sensing" (Preprint, 2007).
% This example is modified from one example of Sparselab.
% Modified by: Shihao Ji, ECE, Duke University
% last change: Jan. 2, 2007
%---------------------------------------------------------
clear all
I0 = imread('Mondrian.tif');
I0 = double(I0);

% Set finest, coarsest scales
j1 = 6;
j0 = 4;
qmf = MakeONFilter('Symmlet',8);

Narr = [0.8, 0.6];
S = 30;

% Do Multi-CS scheme:
% Sample 4^j0 resume coefficients (coarse-scale
% coeffs) at scale 2^(-j0) x 2^(-j0)
alpha0 = FTWT2_PO(I0, j0, qmf);
alpha_LIN = zeros(size(alpha0));
alpha_LIN(1:2^j1,1:2^j1) = alpha0(1:2^j1,1:2^j1);
alpha_BP = zeros(size(alpha0));
alpha_BP(1:2^j0,1:2^j0) = alpha0(1:2^j0,1:2^j0);
alpha_FDR = alpha_BP;
alpha_FAR = alpha_BP;
alpha_BCS = alpha_BP;
%
N_CS = 4^j0;
%
t_BP  = 0;
t_FDR = 0;
t_FAR = 0;
t_BCS = 0;
%
% For each scale, apply CS scheme
for jj = (j0):(j1-1)
    % Construct the vector theta of detail wavelet
    % coeffs on scale jj
    jj
    theta1 = alpha0((2^jj+1):2^(jj+1),1:2^jj);
    theta2 = alpha0(1:2^(jj+1),(2^jj+1):2^(jj+1));
    n1 = prod(size(theta1));
    n2 = prod(size(theta2));
    theta = [theta1(:); theta2(:)];

    Mdetail = 4^(jj+1) - 4^jj;
    Ndetail = floor(Mdetail .* Narr(jj-j0+1));
    N_CS = N_CS + Ndetail;

    % Sample Ndetail compressed samples using the CS operator
    Qstate = 7256157;
    randn('state',Qstate);    
    tic;
    A = MatrixEnsemble(Ndetail, Mdetail, 'USE');
    Matrix_time = toc

    y = A * theta;

    % Solve the CS problem with BP
    tic;
    alpha = SolveBP(A, y, Mdetail,100,0,1e-3);
    t_BP = t_BP + toc;
    fprintf(1,'BP number of nonzero weights: %d\n',sum(alpha~=0));
    alpha_BP((2^jj+1):2^(jj+1),1:2^jj) = reshape(alpha(1:n1), 2^(jj+1)-2^jj, 2^jj);
    alpha_BP(1:2^(jj+1),(2^jj+1):2^(jj+1)) = reshape(alpha(n1+1:n1+n2), 2^(jj+1), 2^(jj+1)-2^jj);
    
    % Solve the CS problem with FDR thresholding
    q = 0.9;
    tic;
    [alpha, iters] = SolveStOMP(A, y, Mdetail, 'FDR', q, S, 1);
    t_FDR = t_FDR + toc;
    alpha_FDR((2^jj+1):2^(jj+1),1:2^jj) = reshape(alpha(1:n1), 2^(jj+1)-2^jj, 2^jj);
    alpha_FDR(1:2^(jj+1),(2^jj+1):2^(jj+1)) = reshape(alpha(n1+1:n1+n2), 2^(jj+1), 2^(jj+1)-2^jj);

    % Solve the CS problem with FAR thresholding
    a_0 = (0.4*Ndetail/Mdetail)/S;
    tic;
    [alpha, iters] = SolveStOMP(A, y, Mdetail, 'FAR', a_0, S, 1);
    t_FAR = t_FAR + toc;
    alpha_FAR((2^jj+1):2^(jj+1),1:2^jj) = reshape(alpha(1:n1), 2^(jj+1)-2^jj, 2^jj);
    alpha_FAR(1:2^(jj+1),(2^jj+1):2^(jj+1)) = reshape(alpha(n1+1:n1+n2), 2^(jj+1), 2^(jj+1)-2^jj);

    % Bayesian CS
    initsigma2 = std(y)^2/1e2;
    tic;
    [weights,used] = BCS_fast_rvm(A, y, initsigma2, 1e-7); % try 1e-8 for higher accuracy
    t_BCS = t_BCS + toc;
    alpha = zeros(Mdetail,1);
    alpha(used) = weights;
    fprintf(1,'BCS number of nonzero weights: %d\n',length(used));
    alpha_BCS((2^jj+1):2^(jj+1),1:2^jj) = reshape(alpha(1:n1), 2^(jj+1)-2^jj, 2^jj);
    alpha_BCS(1:2^(jj+1),(2^jj+1):2^(jj+1)) = reshape(alpha(n1+1:n1+n2), 2^(jj+1), 2^(jj+1)-2^jj);

end

% Reconstruct and compute error
I_LIN = ITWT2_PO(alpha_LIN, j0, qmf);
I_BP  = ITWT2_PO(alpha_BP,  j0, qmf);
I_FDR = ITWT2_PO(alpha_FDR, j0, qmf);
I_FAR = ITWT2_PO(alpha_FAR, j0, qmf);
I_BCS = ITWT2_PO(alpha_BCS, j0, qmf);

E_LIN = norm(I0 - I_LIN,'fro') / norm(I0,'fro');
E_BP  = norm(I0 - I_BP, 'fro') / norm(I0,'fro');
E_FDR = norm(I0 - I_FDR,'fro') / norm(I0,'fro');
E_FAR = norm(I0 - I_FAR,'fro') / norm(I0,'fro');
E_BCS = norm(I0 - I_BCS,'fro') / norm(I0,'fro');


subplot(2,2,1); AutoImage(I_LIN); title(['(a) Linear Reconstruction, K=' num2str(4^j1)]);
subplot(2,2,2); AutoImage(I_FDR); title(['(b) Multiscale CS with CFDR, K=' num2str(N_CS)]);
subplot(2,2,3); AutoImage(I_FAR); title(['(c) Multiscale CS with CFAR, K=' num2str(N_CS)]);
subplot(2,2,4); AutoImage(I_BCS); title(['(d) Multiscale CS with BCS, K=' num2str(N_CS)]);

disp(['LIN: ||I_hat-I||/||I|| = ' num2str(E_LIN)]);
disp(['BP:  ||I_hat-I||/||I|| = ' num2str(E_BP)  ', time = ' num2str(t_BP)  ' secs']);
disp(['FDR: ||I_hat-I||/||I|| = ' num2str(E_FDR) ', time = ' num2str(t_FDR) ' secs']);
disp(['FAR: ||I_hat-I||/||I|| = ' num2str(E_FAR) ', time = ' num2str(t_FAR) ' secs']);
disp(['BCS: ||I_hat-I||/||I|| = ' num2str(E_BCS) ', time = ' num2str(t_BCS) ' secs']);

save Mondrian_results.mat I0 I_LIN I_BP I_FDR I_FAR I_BCS ...
     E_LIN E_BP E_FDR E_FAR E_BCS t_BP t_FDR t_FAR t_BCS N_CS j0 j1;
disp('Done!');
