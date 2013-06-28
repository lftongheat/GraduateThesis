% Figure 14: Multiscale CS reconstrunction of a Mondrian painting.
%
% Data Dependencies:
%   DataFig14.mat (Created by GenDataFig14.m)
%

load DataFig14.mat

figure; 
subplot(2,2,1); AutoImage(I0); title(['(a) Original Image']);
subplot(2,2,2); AutoImage(I_BP); title(['(b) Multiscale CS with BP']);
subplot(2,2,3); AutoImage(I_FDR); title(['(c) Multiscale CS with CFDR']);
subplot(2,2,4); AutoImage(I_FAR); title(['(d) Multiscale CS with CFAR']);

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
