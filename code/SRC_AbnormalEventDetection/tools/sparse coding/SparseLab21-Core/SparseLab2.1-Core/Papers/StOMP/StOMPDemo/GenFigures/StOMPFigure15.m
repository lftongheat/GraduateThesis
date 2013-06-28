% Figure 15: Multiscale CS reconstrunction of a Mondrian painting - close
% up of detail coefficients. 
%
% Data Dependencies:
%   DataFig14.mat (Created by GenDataFig14.m)
%

load DataFig14.mat

jj = j1-2;
qmf = MakeONFilter('Symmlet',8); 

width = 100;
start = 570;
zoom = start:(start+width-1);

theta = FTWT2_PO(I0, j0, qmf);
theta = theta((2^jj+1):2^(jj+1),1:2^jj);
thetaZ = theta(zoom);

alpha = FTWT2_PO(I_BP, j0, qmf);
alpha = alpha((2^jj+1):2^(jj+1),1:2^jj);
alpha_BPZ = alpha(zoom);

alpha = FTWT2_PO(I_FDR, j0, qmf);
alpha = alpha((2^jj+1):2^(jj+1),1:2^jj);
alpha_FDRZ = alpha(zoom);

alpha = FTWT2_PO(I_FAR, j0, qmf);
alpha = alpha((2^jj+1):2^(jj+1),1:2^jj);
alpha_FARZ = alpha(zoom);

figure; 
subplot(2,2,1); plot(thetaZ); axis([1 width -250 150]);
title(['(a) Horizontal slice of ' num2str(width) ' wavelet coefficients at scale ' num2str(jj)]);  
subplot(2,2,2); plot(alpha_BPZ); axis([1 width -250 150]);
title(['(b) Reconstruction with BP']); 
subplot(2,2,3); plot(alpha_FDRZ); axis([1 width -250 150]); 
title(['(c) Reconstruction with CFDR']); 
subplot(2,2,4); plot(alpha_FARZ); axis([1 width -250 150]);
title(['(d) Reconstruction with CFAR']); 
colormap(map);

%
% Copyright (c) 2006. David Donoho, Iddo Drori, and Yaakov Tsaig
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
