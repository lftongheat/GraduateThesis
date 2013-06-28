function ph = NormalDens(x,mu,sigma)
% Normal Probability Density
% p = NormalDens(x,mu,sigma)
if nargin < 2,
    mu = 0; sigma = 1;
end
z = (x-mu)/sigma;
ph1 = exp( - z.^2 ./ 2 ) ./ sqrt(2*pi);
ph  = ph1 ./sigma;


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
