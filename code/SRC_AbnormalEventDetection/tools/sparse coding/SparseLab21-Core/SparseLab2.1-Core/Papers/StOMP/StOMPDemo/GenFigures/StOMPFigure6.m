% Figure 6: Phase diagram for CFAR thresholding
%
% Data Dependencies: 
%   DataFig06.mat (Created by GenDataFig06.m)
%   RhoFAR.mat (Created by FindRhoFAR.m)
%

load DataFig06.mat;
load RhoFAR.mat;

[Delta, Rho] = meshgrid(deltaArr,rhoArr);
K = ceil(Rho .* floor(N .* Delta));
muErrVecL0 = muErrVecL0 .* K;

PhasePlot(muErrVecL0, RhoFAR, deltaArr, deltaLen, rhoArr, rhoLen, N, '');

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
