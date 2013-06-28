function H = shannon(p)
% H = shannon(p)
%  Shannon entropy using natural logs.
%  Section 3.3 in HDCSPNP2P

H = p .*  log(1./p) + (1-p) .* log(1 ./(1-p));

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
