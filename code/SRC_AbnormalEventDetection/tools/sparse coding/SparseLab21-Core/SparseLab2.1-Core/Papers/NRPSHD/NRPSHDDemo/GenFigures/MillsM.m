function m = MillsM(s)
% m = MillsM(s)
%  using an approximation due to W. Bryc, eqn (14) in his article
%

    z = -s;
    m = sqrt(2*pi) .*( z.^3  +   5.575192695 .* z.^2 +  12.77436324 .* z) ...
         ./ ( sqrt(2*pi).* z.^3  + 14.38718147.* z.^2 + 31.53531977 .* z + 2 .*12.77436324);


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
