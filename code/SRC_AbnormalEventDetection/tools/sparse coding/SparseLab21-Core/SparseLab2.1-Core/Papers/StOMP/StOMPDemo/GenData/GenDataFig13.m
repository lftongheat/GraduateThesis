% GenDataFig13: Generate images for figure 13: 
% Multiscale CS reconstruction of 2-D spectra with BP,FDR,FAR.

numObjects = 40;
dim = 256;
I0 = GenRandomGaussians(dim,numObjects,371618);

% Set finest, coarsest scales
j1 = 8;
j0 = 5;
qmf = MakeONFilter('Symmlet',8); 

Narr = [0.5 0.25 0.15];
S = 10;

% Do Multi-CS scheme:
% Sample 4^j0 resume coefficients (coarse-scale 
% coeffs) at scale 2^(-j0) x 2^(-j0)
alpha0 = FWT2_PO(I0, j0, qmf);
alpha_BP = zeros(size(alpha0));
alpha_BP(1:2^j0,1:2^j0) = alpha0(1:2^j0,1:2^j0);
alpha_FDR = alpha_BP;
alpha_FAR = alpha_BP;
N_CS = 4^j0;

t_BP = 0;
t_FDR = 0;
t_FAR = 0;

thetas = cell(j1-j0,1);
alphas_BP = cell(j1-j0,1);
alphas_FDR = cell(j1-j0,1);
alphas_FAR = cell(j1-j0,1);

% For each scale, apply CS scheme
for jj = (j0):(j1-1)
    % Construct the vector theta of detail wavelet 
    % coeffs on scale jj
    theta1 = alpha0((2^jj+1):2^(jj+1),1:2^jj);
    theta2 = alpha0(1:2^(jj+1),(2^jj+1):2^(jj+1));
    n1 = prod(size(theta1));
    n2 = prod(size(theta2));
    theta = [theta1(:); theta2(:)];
    thetas(jj-j0+1) = {theta};

    Mdetail = 4^(jj+1) - 4^jj;
    Ndetail = floor(Mdetail .* Narr(jj-j0+1));
    N_CS = N_CS + Ndetail;

    % Sample Ndetail compressed samples using the CS operator
    y = FastCSOperator(1,Ndetail,Mdetail,theta,1:Mdetail,Mdetail);

    % Solve the CS problem with BP
    tic
    alpha = SolveBP('FastCSOperator', y, Mdetail);
    t_BP = t_BP + toc;
    alpha_BP((2^jj+1):2^(jj+1),1:2^jj) = reshape(alpha(1:n1), 2^(jj+1)-2^jj, 2^jj);
    alpha_BP(1:2^(jj+1),(2^jj+1):2^(jj+1)) = reshape(alpha(n1+1:n1+n2), 2^(jj+1), 2^(jj+1)-2^jj);
    alphas_BP(jj-j0+1) = {alpha_BP};

    % Solve the CS problem with FDR thresholding
    q = 0.9;
    tic
    [alpha, iters] = SolveStOMP('FastCSOperator', y, Mdetail, 'FDR', q, S, 1);
    t_FDR = t_FDR + toc;
    alpha_FDR((2^jj+1):2^(jj+1),1:2^jj) = reshape(alpha(1:n1), 2^(jj+1)-2^jj, 2^jj);
    alpha_FDR(1:2^(jj+1),(2^jj+1):2^(jj+1)) = reshape(alpha(n1+1:n1+n2), 2^(jj+1), 2^(jj+1)-2^jj);
    alphas_FDR(jj-j0+1) = {alpha_FDR};

    % Solve the CS problem with FAR thresholding
    a_0 = (0.4*Ndetail/Mdetail)/S;
    tic
    [alpha, iters] = SolveStOMP('FastCSOperator', y, Mdetail, 'FAR', a_0, S, 1);
    t_FAR = t_FAR + toc;
    alpha_FAR((2^jj+1):2^(jj+1),1:2^jj) = reshape(alpha(1:n1), 2^(jj+1)-2^jj, 2^jj);
    alpha_FAR(1:2^(jj+1),(2^jj+1):2^(jj+1)) = reshape(alpha(n1+1:n1+n2), 2^(jj+1), 2^(jj+1)-2^jj);
    alphas_FAR(jj-j0+1) = {alphas_FAR};
end

% Reconstruct and compute error
I_BP = IWT2_PO(alpha_BP, j0, qmf);
I_FDR = IWT2_PO(alpha_FDR, j0, qmf);
I_FAR = IWT2_PO(alpha_FAR, j0, qmf);

E_BP = norm(I0 - I_BP,'fro') / norm(I0,'fro');
E_FDR = norm(I0 - I_FDR,'fro') / norm(I0,'fro');
E_FAR = norm(I0 - I_FAR,'fro') / norm(I0,'fro');

save DataFig13.mat Narr N_CS j0 j1 I0 I_BP I_FDR I_FAR ...
    t_BP t_FAR t_FDR E_BP E_FAR E_FDR thetas alphas_BP alphas_FDR alphas_FAR

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
