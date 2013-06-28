% Figure 3: CS Reconstruction of `Bumps' from n=340 and n=256 samples, 
% with Translation-Invariant denoising of the latter.

M = 2^10;

sig0 = MakeBumps(M)';
qmf = MakeONFilter('Symmlet',8);

L = 3;
alpha0 = FWT_PO(sig0, L, qmf);

% Generate Random Dictionary
N = 2^8;
Phi = MatrixEnsemble(N,M);

% generate the vector S
S = Phi * alpha0;

% Solve the BP problem
alpha = SolveBP(Phi, S, size(Phi,2), 5);
sig = IWT_PO(alpha,L,qmf);

% Denoise
sigD = TIDenoise(sig', 'S', qmf); 

% Generate Random Dictionary
N2 = 2^9;
Phi = MatrixEnsemble(N2,M);

% generate the vector S
S2 = Phi * alpha0;

% Solve the BP problem
alpha2 = SolveBP(Phi, S2, size(Phi,2), 5);
sig2 = IWT_PO(alpha2,L,qmf);

% Denoise
sigD2 = TIDenoise(sig2', 'S', qmf); 

subplot(2,2,1); plot(sig); 
axis([0 M -2 6]); title(['(a) CS Reconstruction of Bumps, n = ' num2str(N)]);
subplot(2,2,3); plot(sigD); 
axis([0 M -2 6]); title(['(b) T-I denoising of (a)']);
subplot(2,2,2); plot(sig2); 
axis([0 M -2 6]); title(['(c) CS Reconstruction of Bumps, n = ' num2str(N2)]);
subplot(2,2,4); plot(sigD2); 
axis([0 M -2 6]); title(['(d) T-I denoising of (c)']);

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
