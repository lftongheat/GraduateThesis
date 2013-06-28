% Figure 9: Median normalized l_2 error rates over 500 replications
% when the true underlying model is known and estimated directly with
% ordinary least squares. The number of variables is fixed at 500, 
% and the number of observations fixed at 250, delta=n/p =.5. 
% The oracle MSE is directly proportional to the model noise, and 
% increases sharply as the underlying model becomes less sparse. 
% As the number of variables increases to 500, the error rate 
% increases at slightly lower sparsity levels. The data are right 
% truncated at rho=.9 because the OLS MSE approaches infinity as
% rho approaches 1 (i.e. the number of observations equals the number
% of variables).

load Fig9Datazi0.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(1,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    med0 = median(ErrVecL2n4,2);
end
load Fig9Datazi1.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(1,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    med1 = median(ErrVecL2n4,2);
end
load Fig9Datazi2.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(2,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    med2 = median(ErrVecL2n4,2);
end
load Fig9Datazi4.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(4,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    med4 = median(ErrVecL2n4,2);
end
load Fig9Datazi6.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(6,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    med6 = median(ErrVecL2n4,2);
end
load Fig9Datazi9.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(9,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    med9 = median(ErrVecL2n4,2);
end
load Fig9Datazi12.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(12,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    med12 = median(ErrVecL2n4,2);
end
load Fig9Datazi16.mat
if (size(size(ErrVecL2),2) == 4)
    ErrVecL2n3 = squeeze(ErrVecL2(16,:,:,:));
    ErrVecL2n4 = squeeze(ErrVecL2n3(24,:,:)); %selects n~=100 thus delta~=1/2.
    med16 = median(ErrVecL2n4,2);
end

val=45;

plot(1:val,(med16(1:val)'), 'k:')
hold on
plot(1:val,(med12(1:val)'), 'm-.')
plot(1:val,(med9(1:val)'), 'r-.')
plot(1:val,(med6(1:val)'), 'y-')
plot(1:val,(med4(1:val)'), 'c-')
plot(1:val,(med2(1:val)'), 'g-')
plot(1:val,(med1(1:val)'), 'b-')
plot(1:val,(med0(1:val)'), 'k')

legend('z~N(0,16^2)','z~N(0,12^2)','z~N(0,9^2)','z~N(0,6^2)','z~N(0,4^2)','z~N(0,2^2)','z~N(0,1^2)','no noise','location','NorthWest')
title('Oracle OLS Model: L_2 Error levels for \rho, with \delta=.5, p=500');
xlabel('\rho = k / n'); ylabel=('Error');
axis([0 50 0 1.401]); % y-axis equals fig6,7
set(gca,'XtickLabel',[0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1]);
%print -depsc neworaclep500; print -djpeg99 neworaclep500;

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