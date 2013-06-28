function tq = FDRTq(sigma,eps,q)
% find threshold so that
% Ê Ê (1-eps) F_0(t) / eps F_1(t) = q/(1-q)
% Ê F_0 = half-normal, F_1 = half normal, sd = sigma

val = eps*q / ((1-eps) * (1-q));
str = sprintf('erfc(x/sqrt(2))/erfc(x/sqrt(2)/%f) - %f',sigma,val);
tq = fzero( inline(str),2);

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
