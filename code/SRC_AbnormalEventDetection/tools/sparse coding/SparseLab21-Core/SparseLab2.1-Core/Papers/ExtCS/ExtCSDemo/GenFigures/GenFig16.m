% Figure 16: Multiscale CS reconstrunction of Shepp-Logan phantom 
% in the curvelet domain.
% Uses Data file: CurveletMultiCSRes.mat
% See also: GenCurveletMultiCSRes

load CurveletMultiCSres.mat
 
subplot(1,3,1); AutoImage(I0); title(['(a) Original Image']);
subplot(1,3,2); AutoImage(Ilin); title(['(b) Linear reconstruction']);
subplot(1,3,3); AutoImage(ICS); title(['(c) CS Reconstruction']);

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
