% Figure09: Density correction factors. 
% (a) \lambda_s(z), the factor multiplying the standard normal density to
% get the conditioned Gaussian density, null case.
% (b) \xi_s(z), the factor multiplying the standard normal density to
% get the conditioned Gaussian density, nonnull case.

mu =  [ 0.9970   0.6072  0.3811   0.2545   0.1588 ];
tau = [ 0.4459   0.2210  0.1157   0.0639   0.0330 ];
sig = [ 0.4459   0.2275  0.1336   0.0828   0.0493 ];
colorch = 'bgrkmyc';
symbolch = '.ox+*sdv^<>ph';

for s=2:4,
    [lambda,grid] = LambdaCurve(0.*mu(1:s),sig(1:s),sig(1:s),2.3);
    subplot(1,2,1); plot(grid,lambda,colorch(1 + mod(s-1,length(colorch))))
    if s==2,
        hold on
    end
end
hold off
legend('s=2','s=3','s=4')
title('\lambda_s(z) for \mu=0')

%

for s=2:4,
    [lambda,grid] = LambdaCurve(mu(1:s),tau(1:s),sig(1:s),2.3);
    subplot(1,2,2); plot(grid,lambda,colorch(1 + mod(s-1,length(colorch))))
    if s==2,
        hold on
    end
end
hold off
legend('s=2','s=3','s=4')
title('\lambda_s(z) for \mu \neq 0')

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
