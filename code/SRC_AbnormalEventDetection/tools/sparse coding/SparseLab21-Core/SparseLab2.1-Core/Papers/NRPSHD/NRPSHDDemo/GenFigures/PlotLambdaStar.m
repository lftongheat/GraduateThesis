% Plot LambdaStar
gamma = linspace(.005,.99);
%sgamma = RatMillsSolve(1-gamma);
sgamma = SeriesMillsSolve(1-gamma);
ygamma = yFroms(sgamma);
% LambdaStar = sgamma.*ygamma - sgamma.^2/2 - zeta0(sgamma);
% plot(gamma,LambdaStar,'b')
AsympLambdaStar = -sgamma.^2 .* (gamma ./(1-gamma))  ...
                - log(2/pi)/2 ...
                + log( -sgamma ) - log(1 - gamma) ;
plot(gamma,AsympLambdaStar,'r')
title('\Lambda^*(y) vs. y')
xlabel('y')

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
