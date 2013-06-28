% Figure 7: This shows vertical slices at delta=n/p=.5 through the
% Forward Stepwise Phase Diagram (Fig 4), with the number of variables
% now fixed at 500, and the number of replications at 300. As the 
% noise level is increased from sigma = 0 to sigma = 16 the breakdown
% point occurs earlier, ie. for sparser and sparser models. Notice 
% also that with the increase in p from 200 to 500 the breakdown point,
% for the same level of noise, occurs at sparser underlying models.

load Fig7Datazi0.mat
med0 = median(ErrVecL2n,2);
load Fig7Datazi1.mat
med1 = median(ErrVecL2n,2);
load Fig7Datazi2.mat
med2 = median(ErrVecL2n,2);
load Fig7Datazi4.mat
med4 = median(ErrVecL2n,2);
load Fig7Datazi6.mat
med6 = median(ErrVecL2n,2);
load Fig7Datazi9.mat
med9 = median(ErrVecL2n,2);
load Fig7Datazi12.mat
med12 = median(ErrVecL2n,2);
load Fig7Datazi16.mat
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
title('Normalized L_2 Error for \delta = .5, p=500. Stepwise with sqrt(2logp) threshold')
%print -depsc deltahalfp500reps1000; print -djpeg99 deltahalfp500reps1000

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