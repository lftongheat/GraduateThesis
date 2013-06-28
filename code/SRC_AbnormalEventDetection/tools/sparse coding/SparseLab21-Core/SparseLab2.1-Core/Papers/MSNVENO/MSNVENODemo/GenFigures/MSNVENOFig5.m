% Figure 5: This phase diagram shows the implementation of the Forward
% Stepwise Algorithm, but with a False Discovery Rate threshold: a 
% term is added to the model if it has the largest t-statistic of all
% candidate terms and its corresponding p-value is less than the FDR
% value, defined as (.25*(number of terms currently in the model)/
% (total number of variables)). The number of variables is fixed at
% 200. This version of Forward Stepwise has a Phase Transition similar
% to the theoretical curve from Fig 1 (overlaid) rather than the steep 
% dropoff of classical Forward Stepwise. Each color indicates a 
% different median normalized l_2 error of the coefficients
% ||betahat - beta||_2 / ||beta||_2 over 10 realizations.

load Fig5Data
load FaceNeigh

deltaLen = 50;
rhoLen = 50;
deltaArr = linspace(0.05,1,deltaLen);
rhoArr = linspace(0.05,1,rhoLen);
[Delta,Rho] = meshgrid(deltaArr,rhoArr);
zi=16;

pcolor(Delta,Rho,mErrVecL2n); shading interp; colorbar;
hold on
plot(FaceNeigh(:,1),FaceNeigh(:,2),'k','LineWidth',2)
xlabel('\delta = n / p'); ylabel('\rho = k / n'); 
title('Stepwise FDR threshold, Normalized l_2 error; z~N(0,16); p=200');

%
% Copyright (c) 2006. Victoria Stodden
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%