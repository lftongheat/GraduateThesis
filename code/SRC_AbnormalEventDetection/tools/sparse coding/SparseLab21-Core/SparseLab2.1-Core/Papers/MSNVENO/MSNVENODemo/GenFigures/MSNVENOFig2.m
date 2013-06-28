% Figure 2: Phase transition diagram when the sparse model is recovered using the 
% LASSO Algorithm, where the number of variables p=200. The theoretical phase 
% transition curve from Figure 1 has been superimposed. The dark blue area, 
% below the curve, indicates where the algorithm recovered the underlying model 
% with near zero error, but above the curve in the colored area, the algorithm was
% unable to recover the correct model. As you proceed further above the curve, the 
% ability of the algorithm to recover the model progressively drops. As with the
% theoretical phase transition diagram in Fig 1, along the x-axis the level of 
% underdeterminedness decreases, and along the y-axis the level of sparsity of 
% the underlying model increases. Each color indicates a different median 
% normalized $l_2$ error of the coefficients ||betahat - beta||_2 / ||beta||_2 over 
% 30 realizations.


load Fig2Data;
load FaceNeigh;
deltaLen = 47;
rhoLen = 50;
deltaArr = linspace(0.05,1,deltaLen);
rhoArr = linspace(0.05,1,rhoLen);
[Delta,Rho] = meshgrid(deltaArr,rhoArr);

zArr = linspace(0,4,16);
for zi = 16
    mErrVecL2n = (squeeze(median(shiftdim(squeeze(ErrVecL2(zi,:,:,:)),2))))';
    pcolor(Delta,Rho,mErrVecL2n(:,1:47)); shading interp; colorbar;
    xlabel('\delta = n / p'); ylabel('\rho = k / n'); title('LASSO Normalized L_2 error; Noisy Model z~N(0,16)');
    hold on;
    plot(FaceNeigh(:,1),FaceNeigh(:,2),'k','LineWidth',2)
end


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