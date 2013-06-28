function RhoFDR = FindRhoFDR()

horz  =  10;
yild  = .01;
RhoFDR = [];
deltaLen = 50;
rhoLen = 500;
for delta = linspace(0.05,1,deltaLen),
    delta
	goodrho = 0;
	for rho = linspace(0.05,0.5,rhoLen),
        rhoj = rho;                     % rel  number of true  dimensions remaining
        falsej = 1/delta - rho;         % rel. number of false dimensions remaining
        dimj = 1;                       % rel. number of total dimensions remaining
        q0 = min(1/rhoj-1,0.5);
        results = zeros(horz,6);
        for j=1:horz,
            eps_s = rhoj/(rhoj+falsej);
            lambda = sqrt(dimj/rhoj);
            tq = FDRTq(lambda,eps_s,q0);
            alphaj = erfc(tq/sqrt(2));
            betaj  = erfc(tq/sqrt(2)* sqrt(rhoj/dimj));
            results(j,:) = [ rhoj falsej dimj alphaj betaj tq ];
            dimj = dimj - alphaj*falsej - betaj*rhoj;
            falsej = falsej * (1-alphaj);
            rhoj = rhoj * (1-betaj);
            if (dimj < 0) | (rhoj <= yild*rho), break, end
        end
        if rhoj < (yild+.001) .* rho,
            goodresults = results;
            goodrho = rho;
        end
    end
	disp([delta goodrho]), disp(goodresults)
    RhoFDR = [ RhoFDR ; [delta goodrho] ] ;
    save RhoFDR.mat RhoFDR;
end

%
% Copyright (c) 2006. David Donoho
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
