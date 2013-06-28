% Comparison of Rho_F, Rho_FAR and Rho_FDR. 
% 
% Data Dependencies: 
%   RhoF.mat
%   RhoFAR.mat (Created by FindRhoFAR.m)
%   RhoFDR.mat (Created by FindRhoFDR.m)
%

load RhoF.mat;
load RhoFAR.mat;
load RhoFDR.mat;

figure; hold on;
plot(RhoF(:,1), RhoF(:,2),'b','LineWidth',2);
plot(RhoFAR(:,1), RhoFAR(:,2),'g','LineWidth',2);
plot(RhoFDR(:,1), RhoFDR(:,2),'r','LineWidth',2);
xlabel('\delta = n / N');
ylabel('\rho = k / n');
axis([0 1 0 1]);
legend('\rho_{L_1}','\rho_{FAR}','\rho_{FDR}','Location','NorthWest');


%
% Copyright (c) 2006. David Donoho
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
