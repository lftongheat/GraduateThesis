% Figure 9: Signal `Bumps' and its wavelet analysis


n = 2048;
sig0 = MakeBumps(n);

L = 5;
qmf = MakeONFilter('Symmlet',8);
alpha0 = FWT_PO(sig0, L, qmf);

subplot(3,1,1); plot(sig0); 
axis([0 n -2 6]); title('(a) Signal Bumps, m = 2048');
subplot(3,1,2); PlotWaveCoeff(alpha0, L, 0);  
title('(b) Wavelet analysis');
subplot(3,1,3); 
semilogy(reverse(sort(abs(alpha0)))); 
axis([0 n 10^-20 10^5]); 
title(['(c) Coefficient decay (log scale)']);

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
