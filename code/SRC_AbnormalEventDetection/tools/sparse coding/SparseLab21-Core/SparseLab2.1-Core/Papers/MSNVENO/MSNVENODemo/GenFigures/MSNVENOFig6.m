% Figure 6: This shows a single vertical slice of the Phase Diagram 
% for Forward Stepwise (Fig 4), with varying noise levels, with 
% delta=n/p fixed at .5 and the number of variables fixed at 200. 
% Each increase in model noise (from no noise to N(0,16^2)), 
% causes the algorithm to break down at higher sparsity levels. 
% The median of the normalized l_2 error for the coefficient 
% estimates is shown, over 1000 replications.

load Fig6Datazi0.mat
med0 = median(ErrVecL2n,2);
load Fig6Datazi1.mat
med1 = median(ErrVecL2n,2);
load Fig6Datazi2.mat
med2 = median(ErrVecL2n,2);
load Fig6Datazi4.mat
med4 = median(ErrVecL2n,2);
load Fig6Datazi6.mat
med6 = median(ErrVecL2n,2);
load Fig6Datazi9.mat
med9 = median(ErrVecL2n,2);
load Fig6Datazi12.mat
med12 = median(ErrVecL2n,2);
load Fig6Datazi16.mat
med16 = median(ErrVecL2n,2);

plot(1:length(med16),med16','k:')
hold on
plot(1:length(med12),med12','m-.')
plot(1:length(med9),med9','r-.')
plot(1:length(med6),med6','y-')
plot(1:length(med4),med4','c-')
plot(1:length(med2),med2','g-')
plot(1:length(med1),med1','b-')
plot(1:length(med0),med0','k-')

xlabel('\rho = k / n'); ylabel=('Error');
legend('z~N(0,16^2)','z~N(0,12^2)','z~N(0,9^2)','z~N(0,6^2)','z~N(0,4^2)','z~N(0,2^2)','z~N(0,1^2)','no noise','location','SouthEast')
set(gca,'XtickLabel',[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]);
title('Normalized L_2 Error for \delta = .5, p=200. Stepwise with sqrt(2logp) threshold')
%print -depsc deltahalfp200reps1000; print -djpeg99 deltahalfp200reps1000

%
% Copyright (c) 2006. Victoria Stodden
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%