% Figure 10: Ratio of median Forward Stepwise MSE to the median oracle MSE.
% The number of variables is fixed at 200, the number of observations at 100,
% ie. delta=n/p=.5, and the median was taken over 1000 replications. The 
% error rates were truncated at the maximum first difference, to isolate 
% the region in which Forward Stepwise does recover the underlying model 
% correctly. At higher noise levels, the breakdown point occurs at lower 
% sparsity levels, i.e. the model must be more sparse for Forward Stepwise
% to recover it with small error. The errors increase more for Forward 
% Stepwise with increasing noise levels, than for the oracle MSE.

load Fig6Datazi0.mat
med0=median(ErrVecL2n,2);
medd=diff(med0);
ShortmErrVecL2z0 = med0(1:find(medd == max(medd)));
 load Fig6Datazi1.mat
med1=median(ErrVecL2n,2);
medd=diff(med1);
ShortmErrVecL2z1 = med1(1:find(medd == max(medd)));
 load Fig6Datazi2.mat
med2=median(ErrVecL2n,2);
medd=diff(med2);
ShortmErrVecL2z2 = med2(1:find(medd == max(medd)));
 load Fig6Datazi4.mat
med4=median(ErrVecL2n,2);
medd=diff(med4);
ShortmErrVecL2z4 = med4(1:find(medd == max(medd)));
 load Fig6Datazi6.mat
med6=median(ErrVecL2n,2);
medd=diff(med6);
ShortmErrVecL2z6 = med6(1:find(medd == max(medd)));
 load Fig6Datazi9.mat
med9=median(ErrVecL2n,2);
medd=diff(med9);
ShortmErrVecL2z9 = med9(1:find(medd == max(medd)));
 load Fig6Datazi12.mat
med12=median(ErrVecL2n,2);
medd=diff(med12);
ShortmErrVecL2z12 = med12(1:find(medd == max(medd)));
 load Fig6Datazi16.mat
med16=median(ErrVecL2n,2);
medd=diff(med16);
ShortmErrVecL2z16 = med16(1:find(medd == max(medd)));

% load oracle data

load Fig8Datazi0.mat
if (size(size(ErrVecL2),2) == 4), %if the dataset was user created
    ErrVecL2n3 = squeeze(ErrVecL2(1,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle0 = median(ErrVecL2n4,2);
else medoracle0=med0;
end

load Fig8Data.mat
if (size(size(ErrVecL2),2) == 4), %if the dataset was user created
    ErrVecL2n3 = squeeze(ErrVecL2(1,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle1 = median(ErrVecL2n4,2);
    ErrVecL2n3 = squeeze(ErrVecL2(2,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle2 = median(ErrVecL2n4,2);
    ErrVecL2n3 = squeeze(ErrVecL2(4,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle4 = median(ErrVecL2n4,2);
    ErrVecL2n3 = squeeze(ErrVecL2(6,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle6 = median(ErrVecL2n4,2);
    ErrVecL2n3 = squeeze(ErrVecL2(9,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle9 = median(ErrVecL2n4,2);
else
    medoracle1 = med1;
    medoracle2 = med2;
    medoracle4 = med4;
    medoracle6 = med6;
    medoracle9 = med9;
end


load Fig8Datazi1216.mat
if (size(size(ErrVecL2),2) == 4), %if the dataset was user created
    ErrVecL2n3 = squeeze(ErrVecL2(12,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle12 = median(ErrVecL2n4,2);
    ErrVecL2n3 = squeeze(ErrVecL2(16,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle16 = median(ErrVecL2n4,2);
else 
    medoracle12 = med12;
    medoracle16 = med16;
end

% limit the oracle error lengths to the same as for pre-breakdown:

Shortmedoracle0 = medoracle0(1:length(ShortmErrVecL2z0));
Shortmedoracle1 = medoracle1(1:length(ShortmErrVecL2z1));
Shortmedoracle2 = medoracle2(1:length(ShortmErrVecL2z2));
Shortmedoracle4 = medoracle4(1:length(ShortmErrVecL2z4));
Shortmedoracle6 = medoracle6(1:length(ShortmErrVecL2z6));
Shortmedoracle9 = medoracle9(1:length(ShortmErrVecL2z9));
Shortmedoracle12 = medoracle12(1:length(ShortmErrVecL2z12));
Shortmedoracle16 = medoracle16(1:length(ShortmErrVecL2z16));

plot(1:length(Shortmedoracle16),(ShortmErrVecL2z16')./(Shortmedoracle16'), 'k:')
hold on
plot(1:length(Shortmedoracle12),(ShortmErrVecL2z12')./(Shortmedoracle12'), 'm-.')
plot(1:length(Shortmedoracle9),(ShortmErrVecL2z9')./(Shortmedoracle9'), 'r-.')
plot(1:length(Shortmedoracle6),(ShortmErrVecL2z6')./(Shortmedoracle6'), 'y-')
plot(1:length(Shortmedoracle4),(ShortmErrVecL2z4')./(Shortmedoracle4'), 'c-')
plot(1:length(Shortmedoracle2),(ShortmErrVecL2z2')./(Shortmedoracle2'), 'g-')
plot(1:length(Shortmedoracle1),(ShortmErrVecL2z1')./(Shortmedoracle1'), 'b-')
plot(1:length(Shortmedoracle0),(ShortmErrVecL2z0')./(Shortmedoracle0'), 'k')

legend('z~N(0,16^2)','z~N(0,12^2)','z~N(0,9^2)','z~N(0,6^2)','z~N(0,4^2)','z~N(0,2^2)','z~N(0,1^2)','no noise','location','NorthWest')
title('Ratio of Pre-Breakdown MSE to Oracle MSE, with \delta=.5, p=200');
xlabel('\rho = k / n'); ylabel=('Error');
axis([1 12 0.5 3.5]); 
set(gca,'XTickLabel',[0.05 0.07 0.09 0.11 0.13 0.15 0.17 0.19 0.21 0.22 0.24 0.26]);
%print -depsc ratiobkdnoraclep200; print -djpeg99 ratiobkdnoraclep200;

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