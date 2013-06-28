function PhasePlot(Empirical,CurvePredict,deltaArr,deltaLen,rhoArr,rhoLen,N,str)
% Plots a phase diagram of the empirical data, and overlays it with the 
% predicted phase transition. 

[Delta,Rho] = meshgrid(deltaArr,rhoArr);

pcolor(Delta,Rho,Empirical');  
colormap (1-gray); 
shading interp; 
colorbar;
xlabel('\delta = n / N'); ylabel('\rho = k / n'); 
hold on; plot(CurvePredict(:,1),CurvePredict(:,2),'r','LineWidth',2); hold off;
title(str);

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
