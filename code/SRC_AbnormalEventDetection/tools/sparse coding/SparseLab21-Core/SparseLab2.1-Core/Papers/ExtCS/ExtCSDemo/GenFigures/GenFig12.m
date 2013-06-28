% Figure 12: CSDN reconstruction of signal `Bumps', m = 2048, n = 512.

M = 2^11;
N = 2^9;

sig0 = MakeBumps(M)';
qmf = MakeONFilter('Symmlet',8);

SNR = 5;
randn('seed', 2.055615866000000e+09);
[sig0 y]= NoiseMaker(sig0, SNR);

L = 3;
alpha0 = FWT_PO(y, L, qmf);

% Generate Random Dictionary
Phi = MatrixEnsemble(N,M);

% generate the vector S
S = Phi * alpha0;

% Solve the BP problem
alpha = SolveBP(Phi, S, M, 20);
sig = IWT_PO(alpha,L,qmf);

% Solve the BPDN problem
alpha2 = SolveBP(Phi, S, M, 20, 4*sqrt(2*log(M)));
sig2 = IWT_PO(alpha2,L,qmf);

subplot(3,2,1); plot(y); 
axis([0 M -10 20]); title('(a) Noisy Signal');
subplot(3,2,2); PlotWaveCoeff(alpha0, L, 0);  
title('(b) Noisy wavelet coefficients');

subplot(3,2,3); plot(sig); 
axis([0 M -10 20]); title('(c) CS Reconstruction, n = 512');
subplot(3,2,4); PlotWaveCoeff(alpha, L, 0);  
title('(d) CS Reconstruction');

subplot(3,2,5); plot(sig2); 
axis([0 M -10 20]); title('(e) CSDN Reconstruction, n = 512');
subplot(3,2,6); PlotWaveCoeff(alpha2, L, 0);  
title('(f) CSDN Reconstruction');

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
