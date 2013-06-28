% Figure 11: Phase diagram for CFDR thresholding with varying noise level.
%
% Data Dependencies: 
%   DataFig11-SNR10.mat (Created by GenDataFig11(10))
%   RhoFDR.mat
%

load RhoFDR.mat;

SNR = 10;
fname = ['DataFig11-SNR' num2str(SNR) '.mat'];
load(fname);

str = ['Gaussian Coefficients, SNR = ' num2str(10*log10(SNR),2) 'dB'];
PhasePlot(muErrVecL2, RhoFDR, deltaArr, deltaLen, rhoArr, rhoLen, N, str);
caxis([0 1.5]); colorbar;

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
