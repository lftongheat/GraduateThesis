function psinu = PsiExt(nu)
% psinu = PsiExt(nu)
% Calculate PsiExt as defined in Section 4.1 of HDPCSPwNP2D
%

xnu = CalcXnu(nu);
psinu = -(1-nu) .* log( erf(xnu) ) + nu .* xnu.^2;

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