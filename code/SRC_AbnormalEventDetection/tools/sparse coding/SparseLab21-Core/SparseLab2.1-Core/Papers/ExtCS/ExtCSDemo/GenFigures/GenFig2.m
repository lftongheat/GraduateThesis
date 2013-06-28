% Figure 2: Signal `Blocks' and its expansion in a Haar wavelet basis

n = 2048;
sig0 = MakeBlocks(n);
qmf = MakeONFilter('Haar',1);
L = 4;
alpha0 = FWT_PO(sig0, L, qmf);

subplot(2,1,1); plot(sig0); 
axis([0 n -4 6]); title('(a) Signal Blocks, m = 2048');

subplot(2,1,2); PlotWaveCoeff(alpha0, L, 0);  
title('(b) Wavelet analysis');

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
