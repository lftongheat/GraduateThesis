% Plot Xnu
nu = linspace(.01,.99);
xnu = CalcXnu(nu);
%fg1= figure;
plot(nu,xnu,'r')
hold on;
asympxnu = sqrt(log(1./(sqrt(pi) .* nu)));
plot(nu(nu < .5),asympxnu(nu < .5),'g')
title('x_\nu (red) and asymptotic approximation (green)')
xlabel('\nu')
hold off;

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
