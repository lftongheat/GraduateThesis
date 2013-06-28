function psi = PsiFace(nu,rho,delta)
% Synopsis
%  psi = PsiFace(nu,rho,delta)
% Description 
%  Calculate Exponents of Number of Faces
%  See Section 7.1 in HDCSPwNP2D

psi =  rho.*delta.* log(2) + shannon(rho.*delta);

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