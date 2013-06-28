% GenRectMultiRes: Generates panel (c) of figure 15, Multiscale CS
% reconstruction of Mondrian image.

close all;

n = 1024;
I0 = GenRandomRects(n, 6);
qmf = MakeONFilter('Haar',1); 

% Set finest, coarsest scales
j1 = 6;
j0 = 3;

% First, linear sampling by measuring 4^j1 coeffs
% (of scaling functions on scale 2^(-j1) x 2^(-j1)
alpha0 = FWT2_PO(I0, j1, qmf);
alpha_lin = zeros(size(alpha0));
alpha_lin(1:2^j1,1:2^j1) = alpha0(1:2^j1,1:2^j1);

% Reconstruct and compute error
I_lin = IWT2_PO(alpha_lin, j1, qmf);
E_lin = twonorm(I0 - I_lin) / twonorm(I0);

% Now, do CS scheme
% Sample 4^j0 resume coefficients (coarse-scale 
% coeffs) at scale 2^(-j0) x 2^(-j0)
alpha0 = FWT2_PO(I0, j0, qmf);
alpha_CS = zeros(size(alpha0));
alpha_CS(1:2^j0,1:2^j0) = alpha0(1:2^j0,1:2^j0);
N_CS = 4^j0;

Narr = [0.75 0.5 0.15];

% For each scale, apply CS scheme
for jj = (j0):(j1-1)
    % Construct the vector theta of detail wavelet 
    % coeffs on scale jj
    theta1 = alpha0((2^jj+1):2^(jj+1),1:2^jj);
    theta2 = alpha0(1:2^(jj+1),(2^jj+1):2^(jj+1));
    n1 = prod(size(theta1));
    n2 = prod(size(theta2));
    theta = [theta1(:); theta2(:)];

    Mdetail = 4^(jj+1) - 4^jj;
    Ndetail = floor(Mdetail .* Narr(jj-j0+1));
    N_CS = N_CS + Ndetail;

    % Solve the BP problem
    alpha = SolveFastCS(theta, Ndetail);
    alpha_CS((2^jj+1):2^(jj+1),1:2^jj) = reshape(alpha(1:n1), 2^(jj+1)-2^jj, 2^jj);
    alpha_CS(1:2^(jj+1),(2^jj+1):2^(jj+1)) = reshape(alpha(n1+1:n1+n2), 2^(jj+1), 2^(jj+1)-2^jj);
end

% Reconstruct and compute error
I_CS = IWT2_PO(alpha_CS, j0, qmf);
E_CS = twonorm(I0 - I_CS) / twonorm(I0);

save RectMultiRes.mat E_CS E_lin I0 I_CS I_lin N_CS

%
% Copyright (c) 2006. Yaakov Tsaig
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
