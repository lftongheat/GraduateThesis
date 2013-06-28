% Figure 15: Reconstruction of Mondrian Image using Hybrid & Multiscale CS.
% Uses Data files: RectHybridRes.mat RectMultiRes.mat
% See also: GenRectMultiRes, GenRectHybridRes

load RectHybridRes.mat

subplot(1,3,1); AutoImage(I_lin); title(['(a) Linear reconstruction, n = ' num2str(4^j1)]);
subplot(1,3,2); AutoImage(I_CS); title(['(b) Hybrid CS Reconstruction, n = ' num2str(Ndetail)]);

load RectMultiRes.mat

subplot(1,3,3); AutoImage(I_CS); title(['(b) Multiscale CS Reconstruction, n = ' num2str(Ndetail)]);


%
% Copyright (c) 2006. Yaakov Tsaig
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
