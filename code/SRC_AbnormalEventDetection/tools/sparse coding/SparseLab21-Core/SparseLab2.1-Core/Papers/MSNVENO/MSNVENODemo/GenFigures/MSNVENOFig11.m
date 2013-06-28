% Figure 11: Ratio of median Forward Stepwise MSE to the median oracle MSE.
% The number of variables is fixed at 500, the number of observations at 250,
% maintaining delta=n/p=.5, and the median was taken over 300 replications.
% The error rates were truncated at the maximum first difference, isolating 
% the region in which Forward Stepwise does recover the underlying model 
% correctly. For Forward Stepwise, the median MSE is roughly 1-2 times that 
% of the median oracle MSE, and at higher noise levels, the breakdown point 
% occurs at lower sparsity levels. The errors increase more for Forward
% Stepwise with increasing noise levels, than for the oracle MSE. The change 
% in the number of variables from 200 to 500 causes the Forward Stepwise MSE
% to increase and implies a breakdown point at lower sparsity levels.

load Fig7Datazi0.mat
med0=median(ErrVecL2n,2);
medd=diff(med0);
ShortmErrVecL2z0 = med0(1:find(medd == max(medd)));
 load Fig7Datazi1.mat
med1=median(ErrVecL2n,2);
medd=diff(med1);
ShortmErrVecL2z1 = med1(1:find(medd == max(medd)));
 load Fig7Datazi2.mat
med2=median(ErrVecL2n,2);
medd=diff(med2);
ShortmErrVecL2z2 = med2(1:find(medd == max(medd)));
 load Fig7Datazi4.mat
med4=median(ErrVecL2n,2);
medd=diff(med4);
ShortmErrVecL2z4 = med4(1:find(medd == max(medd)));
 load Fig7Datazi6.mat
med6=median(ErrVecL2n,2);
medd=diff(med6);
ShortmErrVecL2z6 = med6(1:find(medd == max(medd)));
 load Fig7Datazi9.mat
med9=median(ErrVecL2n,2);
medd=diff(med9);
ShortmErrVecL2z9 = med9(1:find(medd == max(medd)));
 load Fig7Datazi12.mat
med12=median(ErrVecL2n,2);
medd=diff(med12);
ShortmErrVecL2z12 = med12(1:find(medd == max(medd)));
 load Fig7Datazi16.mat
med16=median(ErrVecL2n,2);
medd=diff(med16);
ShortmErrVecL2z16 = med16(1:find(medd == max(medd)));

% load oracle data

load Fig9Datazi0.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(1,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle0 = median(ErrVecL2n4,2);
else medoracle0 = med0;
end
load Fig9Datazi1.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(1,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle1 = median(ErrVecL2n4,2);
else medoracle1 = med1;
end
load Fig9Datazi2.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(2,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle2 = median(ErrVecL2n4,2);
else medoracle2 = med2;
end
load Fig9Datazi4.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(4,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle4 = median(ErrVecL2n4,2);
else medoracle4 = med4;
end
load Fig9Datazi6.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(6,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle6 = median(ErrVecL2n4,2);
else medoracle6 = med6;
end
load Fig9Datazi9.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(9,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle9 = median(ErrVecL2n4,2);
else medoracle9 = med9;
end
load Fig9Datazi12.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(12,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle12 = median(ErrVecL2n4,2);
else medoracle12 = med12;
end
load Fig9Datazi16.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(16,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    medoracle16 = median(ErrVecL2n4,2);
else medoracle16 = med16;
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

legend('z~N(0,16^2)','z~N(0,12^2)','z~N(0,9^2)','z~N(0,6^2)','z~N(0,4^2)','z~N(0,2^2)','z~N(0,1^2)','no noise','location','NorthEast')
title('Ratio of Pre-Breakdown MSE to Oracle MSE, with \delta=.5, p=500                  ');
xlabel('\rho = k / n'); ylabel=('Error');
axis([0 12 0.5 3]); 
set(gca,'XTickLabel',[0,0.04,0.08,0.12,0.16,0.20,0.22,0.27])
%print -depsc ratiobkdnoraclep500; print -djpeg99 ratiobkdnoraclep500;

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