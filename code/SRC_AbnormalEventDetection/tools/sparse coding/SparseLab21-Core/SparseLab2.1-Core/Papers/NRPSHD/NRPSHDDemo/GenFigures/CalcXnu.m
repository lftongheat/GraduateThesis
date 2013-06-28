function xnu = CalcXnu(nu)
% xnu = CalcXnu(nu)
% solve (1-nu)/nu = 2 Q(xnu) xnu/q(xnu)  
% Q=\pi^(-1/2)\int_{-\infty}^x exp(-y^2)dy

% check that nu is in range.
if max(nu(:)) >= 1 | min( nu(:)) <= 0,
    disp(' Error in CalcXnu: nu outside (0,1) ')
end

%as xxnu>=0 we add one to the integral of G(xnu) to get Q(xnu)
%this change is seen exhibited in computing pnu

% build table 
xxnu = linspace(0,5,5000);
pnu = (1+erf(xxnu))/2;
eden = exp(-xxnu.^2)./sqrt(pi);       % density of erf
gxnu = xxnu .* pnu ./eden  ;          % left side of (4.2)*2
wnu = (1-nu)./(2.*nu);                % right side of (4.2)/2
xnu = interp1(gxnu,xxnu,wnu);         % x making left = right 

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
