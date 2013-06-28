% Figure 3: This diagram displays the median error rates when the LARS Algorithm 
% is used to recover the underlying sparse model, with the number of variables, 
% p, fixed at 200. The algorithm does not find the correct model well above the 
% threshold, and seems to have trouble when there are as many predictors as 
% observations. Each color indicates a different median normalized l_2 error of the
% coefficients ||betahat - beta||_2 / ||beta||_2 over 30 realizations.
 
load Fig3Data
load FaceNeigh
deltaLen = 50;
rhoLen = 50;
deltaArr = linspace(0.05,1,deltaLen);
rhoArr = linspace(0.05,1,rhoLen);
[Delta,Rho] = meshgrid(deltaArr,rhoArr);

zi = 16;

mErrVecL2n = (squeeze(median(shiftdim(squeeze(ErrVecL2(zi,:,:,:)),2))))';
 for i=1:50,
     for j=1:50,
         if (mErrVecL2n(i,j) > 1)
             mErrVecL2n(i,j) = 1;
         end
     end
 end
pcolor(Delta,Rho,mErrVecL2n); shading interp; colorbar;
hold on
    plot(FaceNeigh(:,1),FaceNeigh(:,2),'k','LineWidth',2)
xlabel('\delta = n / p'); ylabel('\rho = k / n'); title('LARS Normalized l_2 error; z \sim N(0,16)');
   

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