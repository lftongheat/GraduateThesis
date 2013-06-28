% Table03: Comparison of running times on the partial Fourier problem suite, 
% for BP,OMP,CFDR,CFAR.
%
% Data Dependencies:
%   DataTbl03.mat (Created by GenDataTbl03.m)
%

load DataTbl03.mat

% Print the results in TeX format
for ii = 1:length(NArr)
    fprintf('(%d,%d,%d) & %5.2f & %5.2f & %5.2f & %5.2f \\\\ \n', ...
        kArr(ii),nArr(ii),NArr(ii),tBP(ii),tOMP(ii),tFAR(ii),tFDR(ii));
end
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
