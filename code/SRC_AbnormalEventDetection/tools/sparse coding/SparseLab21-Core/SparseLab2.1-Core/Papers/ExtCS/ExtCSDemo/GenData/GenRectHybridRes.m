% GenRectHybridRes: Generates panel (b) of figure 15, Hybrid CS
% reconstruction of Mondrian image.

close all;

n = 1024;
I0 = zeros(n);
I0 = GenRandomRects(n, 6);
qmf = MakeONFilter('Haar',1); 

% Set finest, coarsest scales
j1 = 6;
j0 = ceil(j1/2);
c = 0.5;

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
Phi = MatrixEnsemble(Ndetail, Mdetail);

% generate the vector S (random measurments of detail coeffs)
S = Phi * theta;

% Solve the BP problem
alpha = SolveBP(Phi, S);
alpha_CS((2^j0+1):2^j1,1:2^j0) = reshape(alpha(1:n1), 2^j1-2^j0, 2^j0);
alpha_CS(1:2^j1,(2^j0+1):2^j1) = reshape(alpha(n1+1:n1+n2), 2^j1, 2^j1-2^j0);

% Reconstruct and compute error
I_CS = IWT2_PO(alpha_CS, j0, qmf);
E_CS = twonorm(I0 - I_CS) / twonorm(I0);

save RectHybridRes.mat E_CS E_lin I0 I_CS I_lin Mdetail Ndetail

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

