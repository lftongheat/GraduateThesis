function y = yFroms(s)
%  y = yFroms(s)
%
%  Calculates the y dual to s
%  Eqn (6.9) in HDCSPNP2P

y = s + zeta1(s);

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
