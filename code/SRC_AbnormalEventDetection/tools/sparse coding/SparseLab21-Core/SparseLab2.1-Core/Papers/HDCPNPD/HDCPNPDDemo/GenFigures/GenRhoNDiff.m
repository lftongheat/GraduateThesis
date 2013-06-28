function y = GenRhoNDiff(rho)

global newdelt
delta = newdelt;
nu = delta;
y  = PsiNet(nu,rho,delta,1);

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
