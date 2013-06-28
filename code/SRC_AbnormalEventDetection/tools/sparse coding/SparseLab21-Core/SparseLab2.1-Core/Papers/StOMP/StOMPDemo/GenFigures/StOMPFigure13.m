% Figure 13: Multiscale CS reconstrunction of synthesized 2-D spectra
%
% Data Dependencies:
%   DataFig13.mat (Created by GenDataFig13.m)
%

load DataFig13.mat

map = linspace(0.2,0.8,32);
map = [map reverse(map) map reverse(map)];
map = [map', map', map'];

subplot(2,2,1); surf(I0); shading interp; axis([0 256 1 256 0 0.75]);
title(['(a) Original Image']); axis off;
subplot(2,2,2); surf(I_BP); shading interp; axis([0 256 1 256 0 0.75]);
title(['(b) Multiscale CS with BP']); axis off;
subplot(2,2,3); surf(I_FDR); shading interp; axis([0 256 1 256 0 0.75]);
title(['(c) Multiscale CS with CFDR']); axis off;
subplot(2,2,4); surf(I_FAR); shading interp; axis([0 256 1 256 0 0.75]);
title(['(d) Multiscale CS with CFAR']); axis off;
colormap(map);

disp(['BP: ||I_hat-I||/||I|| = ' num2str(norm(I0-I_BP,'fro')./norm(I0,'fro'),3) ... 
    ', time = ' num2str(t_BP,2) ' secs']);
disp(['FDR: ||I_hat-I||/||I|| = ' num2str(norm(I0-I_FDR,'fro')./norm(I0,'fro'),3) ... 
    ', time = ' num2str(t_FDR,2) ' secs']);
disp(['FAR: ||I_hat-I||/||I|| = ' num2str(norm(I0-I_FAR,'fro')./norm(I0,'fro'),3) ... 
    ', time = ' num2str(t_FAR,2) ' secs']);

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
