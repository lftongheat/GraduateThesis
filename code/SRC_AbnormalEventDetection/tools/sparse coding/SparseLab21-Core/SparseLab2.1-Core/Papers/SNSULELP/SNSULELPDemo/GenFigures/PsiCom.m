function psi = PsiCom(nu,rho,delta)
% Synopsis
%  psi = PsiCom(nu,rho,delta)
% Description 
%  Calculate Exponents of Combinatorial Factor

psi = shannon(rho.*delta) + (1-rho.*delta).*shannon((nu-rho.*delta)./(1-rho.*delta));

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
