function xnu = CalcXnu(nu)
% xnu = CalcXnu(nu)
% solve (1-nu)/nu = 2 G(xnu) xnu/g(xnu)  
% G is PDF of halfnormal with variance 1/2. i.e. erf!
% Eqn (4.2) of HDCSPwNP2N

% check that nu is in range.
if max(nu(:)) >= 1 | min( nu(:)) <= 0,
    disp(' Error in CalcXnu: nu outside (0,1) ')
end

% build table 
xxnu = linspace(0,12,500);
pnu = erf(xxnu);
eden = 2.*exp(-xxnu.^2)./sqrt(pi);    % density of erf
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
