% Figure 14: Hybrid CS and Multiscale CS reconstruction of signal `Bumps'.

M = 2^14;

sig0 = MakeBumps(M)';
qmf = MakeONFilter('Symmlet',8); 

% Set finest, coarsest scales
j1 = 10;
j0 = j1/2;
c = 1;

% First, linear sampling by measuring 2^j1 coeffs
% (of scaling functions on scale 2^(-j1)
alpha0 = FWT_PO(sig0, j1, qmf);
alpha_lin = zeros(size(alpha0));
alpha_lin(1:2^j1) = alpha0(1:2^j1);

% Reconstruct and compute error
sig_lin = IWT_PO(alpha_lin, j1, qmf);
E_lin = twonorm(sig0 - sig_lin) / twonorm(sig0);


% Do Hybrid CS scheme
% Sample 2^j0 coarse-scale coeffs) at scale 2^(-j0)
alpha0 = FWT_PO(sig0, j0, qmf);

alpha_Hybrid = zeros(size(alpha0));
alpha_Hybrid(1:2^j0) = alpha0(1:2^j0);
NHybrid = 2^j0;

% Construct a vector of wavelet coeffs at fine scales
theta = alpha0(setdiff(1:2^j1, 1:2^j0));
Mdetail = length(theta);
Ndetail = 608;
NHybrid = NHybrid + Ndetail;

% Generate Random Dictionary
Phi = MatrixEnsemble(Ndetail, Mdetail);

% generate the vector S (random measurments of detail coeffs)
S = Phi * theta;

% Solve the BP problem
alpha = SolveBP(Phi, S, size(Phi,2), 5);
alpha_Hybrid(setdiff(1:2^j1, 1:2^j0)) = alpha;

sig_Hybrid = IWT_PO(alpha_Hybrid, j0, qmf);

% Do Multiscale CS scheme
% Sample 2^j0 coarse-scale coeffs) at scale 2^(-j0)
alpha0 = FWT_PO(sig0, j0, qmf);

alpha_Multi = zeros(size(alpha0));
alpha_Multi(1:2^j0) = alpha0(1:2^j0);
NMulti = 2^j0;

Narr = 2.^(j0:(j1-1));
Narr = min(Narr, 144);

% For each scale, apply CS scheme
for jj = j0:(j1-1)
    % Construct a vector of wavelet coeffs at scale jj
    theta = alpha0(dyad(jj));
    Mdetail = length(theta);
    Ndetail = Narr(jj-j0+1);
    NMulti = NMulti + Ndetail;
    
    % Generate Random Dictionary
    Phi = MatrixEnsemble(Ndetail, Mdetail);

    % generate the vector S (random measurments of detail coeffs)
    S = Phi * theta;

    % Solve the BP problem
    alpha = SolveBP(Phi, S, size(Phi,2), 5);
    alpha_Multi(dyad(jj)) = alpha;
end

% Reconstruct and compute error
sig_Multi = IWT_PO(alpha_Multi, j0, qmf);

subplot(3,1,1); plot(sig_lin); axis([0 M -2 6]);
title(['(a) Linear reconstruction, n = ' num2str(2^j1)]);

subplot(3,1,2); plot(sig_Hybrid); axis([0 M -2 6]);
title(['(b) Hybrid CS reconstruction, n = ' num2str(NHybrid)]);

subplot(3,1,3); plot(sig_Multi); axis([0 M -2 6]);
title(['(c) Multiscale CS reconstruction, n = ' num2str(NMulti)]);

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
