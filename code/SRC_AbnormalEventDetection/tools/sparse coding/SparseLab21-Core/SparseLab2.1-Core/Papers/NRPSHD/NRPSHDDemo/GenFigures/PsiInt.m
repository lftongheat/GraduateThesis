function psi = PsiInt(nu,rho,delta)
% Synopsis
%  psi = PsiInt(nu,rho,delta)
% Description 
%  Calculate Exponents of Internal Angle
%  See Eqn (6.15) in HDCSPwNP2D

gamma = rho.*delta./nu;
t = SeriesMillsSolve(1-gamma);


psi = rho.* delta .* t.^2./2 + (nu - rho.*delta) .* log((nu-rho.*delta)./nu) ...
      + (nu - rho.*delta) .*log(1./(sqrt(2.*pi).*(-t)));
psi = -psi;


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
