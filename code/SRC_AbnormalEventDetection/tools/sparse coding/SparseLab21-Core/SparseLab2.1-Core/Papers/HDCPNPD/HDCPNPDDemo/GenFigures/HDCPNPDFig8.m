%Figure 8.1a

nu = linspace(.01,.99);
Omega = shannon(nu) - PsiExt(nu);
plot(nu,Omega)
title('\Omega(\nu)')
xlabel('\nu')
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
