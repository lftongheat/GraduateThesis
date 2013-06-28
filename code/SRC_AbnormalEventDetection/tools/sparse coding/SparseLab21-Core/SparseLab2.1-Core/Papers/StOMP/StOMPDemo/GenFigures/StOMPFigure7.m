% Figure 7: Phase diagram for CFDR thresholding
%
% Data Dependencies: 
%   DataFig07.mat (Created by GenDataFig07.m)
%   RhoFDR.mat (Created by FindRhoFDR.m)
%

load DataFig07.mat;
load RhoFDR.mat;

[Delta, Rho] = meshgrid(deltaArr,rhoArr);
K = ceil(Rho .* floor(N .* Delta));
muErrVecL0 = muErrVecL0 .* K;

PhasePlot(muErrVecL0, RhoFDR, deltaArr, deltaLen, rhoArr, rhoLen, N, '');

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
