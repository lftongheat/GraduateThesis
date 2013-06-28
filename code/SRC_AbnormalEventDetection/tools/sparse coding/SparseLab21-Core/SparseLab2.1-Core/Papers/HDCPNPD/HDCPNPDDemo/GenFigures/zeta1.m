function xi = zeta1(s)
%  xi = zeta1(s)
%
%  zeta1(s) is the logarithmic derivative of
%         2 Phi(s)
%  where  Phi(s) denotes normal CDF
%  Eqn (6.9) in HDCSPNP2P
%  zeta1(s) = phi(s)/Phi(s)
%  where phi(s) is the normal density.
%  We use the fact that phi(s)/Phi(s)
%  is related to the so-called Mills'' ratio. 
% Phi =  1/2 - erf(-s./sqrt(2))./2;
% lphi = exp(-s.^2./2)./sqrt(2*pi);
% xi = lphi./Phi;

xi = abs(s)./MillsM(s);

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
