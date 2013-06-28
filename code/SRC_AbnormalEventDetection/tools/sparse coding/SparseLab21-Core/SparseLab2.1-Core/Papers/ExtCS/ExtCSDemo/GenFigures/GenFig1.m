% Figure 1: Error of reconstruction versus number of samples 
% for signals with a controlled number of nonzeros.
% Data files used: DataL0_20.mat, DataL0_50.mat, DataL0_100.mat
% See also: GenDataL0.m

load DataL0_20.mat;

subplot(3,1,1); plot(N,E,'-k'); grid on;
axis([0 512 0 1.5]);
ylabel('|| x_{1,n} - x_{0} ||_{2}');
title(['(a) k = ' num2str(K)]);

load DataL0_50.mat;

subplot(3,1,2); plot(N,E,'-k'); grid on;
axis([0 512 0 1.5]);
ylabel('|| x_{1,n} - x_{0} ||_{2}');
title(['(b) k = ' num2str(K)]);

load DataL0_100.mat;

subplot(3,1,3); plot(N,E,'-k'); grid on;
axis([0 512 0 1.5]);
ylabel('|| x_{1,n} - x_{0} ||_{2}');
title(['(c) k = ' num2str(K)]);

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
