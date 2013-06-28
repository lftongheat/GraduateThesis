% Figure 4: Phase diagram when the underlying sparse model is recovered
% using the Forward Stepwise Algorithm, with the number of variables, p,
% fixed at 200. Variables were greedily added to the model until no 
% remaining t-statistic was greater than sqrt{2log(p)}. The phase transition 
% is striking here: there is a very sharp dropoff below which the algorithm
% recovers the model with near zero error, and above which the model is 
% unrecoverable. Along the x-axis the level of underdeterminedness decreases,
% and along the y-axis the level of sparsity of the underlying model 
% increases. Each color indicates a different median normalized l_2
% error of the coefficients ||betahat - beta||_2 / ||beta||_2 over 30
% realizations.

load Fig4Data;

deltaLen = 50;
rhoLen = 50;
deltaArr = linspace(0.05,1,deltaLen);
rhoArr = linspace(0.05,1,rhoLen);
[Delta,Rho] = meshgrid(deltaArr,rhoArr);
zi=4;

mErrVecL2n = (squeeze(median(shiftdim(squeeze(ErrVecL2(zi,:,:,:)),2))))';
    pcolor(Delta,Rho,mErrVecL2n); shading interp; colorbar;
    xlabel('\delta = n / p'); ylabel('\rho = k / n');
    title('Normalized L_2 Error, sqrt(2log(p)) threshold, z~N(0,4^2)')


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