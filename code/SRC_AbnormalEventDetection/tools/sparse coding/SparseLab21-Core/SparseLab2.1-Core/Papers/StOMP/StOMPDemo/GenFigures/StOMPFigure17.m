% Figure 17: BER performance of Error-Correcting Codes with ITSP.
%
% Data Dependencies:
%   DataFig17.mat (Created by GenDataECC(4096,17/16,100,1024,'DataFig17.mat'))
%

load DataFig17.mat

figure; 
subplot(2,2,1); 
plot(kArr,BER_FAR,'--r','LineWidth',2);
ylabel('BER'); xlabel('k'); grid on;
title(['(a) CFAR, avg. time = ' num2str(mean(t_FAR),2) ' secs']);
axis([kArr(1) kArr(length(kArr)) 0 0.1]);

subplot(2,2,2); 
plot(kArr,BER_FDR,'--r','LineWidth',2);
ylabel('BER'); xlabel('k'); grid on;
title(['(b) CFDR, avg. time = ' num2str(mean(t_FDR),2) ' secs']);
axis([kArr(1) kArr(length(kArr)) 0 0.1]);

subplot(2,2,3); 
plot(kArr,BER_PDCO,'--r','LineWidth',2);
ylabel('BER'); xlabel('k'); grid on;
title(['(c) BP, avg. time = ' num2str(mean(t_PDCO),3) ' secs']);
axis([kArr(1) kArr(length(kArr)) 0 0.1]);

subplot(2,2,4); 
plot(kArr,BER_OMP,'--r','LineWidth',2);
ylabel('BER'); xlabel('k'); grid on;
title(['(d) OMP, avg. time = ' num2str(mean(t_OMP),3) ' secs']);
axis([kArr(1) kArr(length(kArr)) 0 0.1]);

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
