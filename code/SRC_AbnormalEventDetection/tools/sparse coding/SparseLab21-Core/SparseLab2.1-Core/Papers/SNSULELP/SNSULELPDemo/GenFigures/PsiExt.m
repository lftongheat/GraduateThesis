function psinu = PsiExt(nu)
% psinu = PsiExt(nu)
% Calculate PsiExt 
%

%erf is replaced by (1+erf)/2 to change from G(y) to Q(y)

xnu = CalcXnu(nu);
psinu = -(1-nu) .* log( (1+erf(xnu))/2 ) + nu .* xnu.^2;

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
