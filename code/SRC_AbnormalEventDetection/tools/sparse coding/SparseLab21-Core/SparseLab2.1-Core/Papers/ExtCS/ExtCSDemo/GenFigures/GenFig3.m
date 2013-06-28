% Figure 3: CS Reconstruction of `Blocks' from n=340 and n=256 samples, 
% with Translation-Invariant denoising of the latter.

M = 2^11;
N = 2^8;

sig0 = MakeBlocks(M)';
qmf = MakeONFilter('Haar',1);

L = 0;
alpha0 = FWT_PO(sig0, L, qmf);

% Generate Random Dictionary
Phi = MatrixEnsemble(N,M);

% generate the vector S
S = Phi * alpha0;

% Solve the BP problem
alpha = SolveBP(Phi, S, M, 30, 0, 1e-4);
sig = IWT_PO(alpha,L,qmf);

% Denoise
sigD = TIDenoise(sig', 'H', qmf); 

% Generate Random Dictionary
N2 = 340;
Phi = MatrixEnsemble(N2,M);

% generate the vector S
S2 = Phi * alpha0;

% Solve the BP problem
alpha2 = SolveBP(Phi, S2, M, 30, 0, 1e-4);
sig2 = IWT_PO(alpha2,L,qmf);

subplot(3,1,1); plot(sig2); 
axis([0 M -4 6]); title(['(a) CS Reconstruction of Blocks, n = ' num2str(N2)]);
subplot(3,1,2); plot(sig); 
axis([0 M -4 6]); title(['(b) CS Reconstruction of Blocks, n = ' num2str(N)]);
subplot(3,1,3); plot(sigD); axis([0 M -4 6]); 
title(['(c) T-I denoising of reconstruction with n = ' num2str(N)]);

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
