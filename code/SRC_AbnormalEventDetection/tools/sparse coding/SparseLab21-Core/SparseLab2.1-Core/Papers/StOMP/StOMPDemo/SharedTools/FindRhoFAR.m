% FindRhoFAR: Prediction of the phase transition for StOMP with CFAR
% thresholding. 

horz  =  10;
yild  = .01;
RhoFAR = [];
deltaLen = 50;
rhoLen = 500;
for delta = linspace(0.05,1,deltaLen),
	goodrho = 0;
	for rho= linspace(0.05,1,rhoLen),
        rhoj = rho;             
        falsej = 1/delta - rho;
        dimj = 1;
        alphaj = delta * (1 - rhoj) / horz;
        zj = norminv2(1-alphaj/2);
        results = zeros(horz,5);
        for j=1:horz,
            betaj = erfc(zj/sqrt(2)*sqrt(rhoj/dimj)); % 2*(1-normalcdf(x)) = erfc(x/sqrt(2))
            results(j,:) = [ rhoj falsej dimj alphaj betaj ];
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
    RhoFAR = [ RhoFAR ; [delta goodrho] ] ;
end

save RhoFAR.mat RhoFAR


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
