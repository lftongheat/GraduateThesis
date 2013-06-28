function psi = PsiNet(nu,rho,delta,which)
% psi = PsiNet(nu,rho,delta,which)
% Calculate net exponent 
% as defined in Section 3.4 of HDCSPwNP2N
%

if nargin < 4,      % by default, PsiNet as in Section 3.4
      which = 1;
end

Psi1 =  PsiCom(nu,rho,delta);
Psi2 =  PsiInt(nu,rho,delta);
Psi3 =  PsiExt(nu);
psi = Psi1 - Psi2 - Psi3;

if which ==3,
  psi = psi - PsiFace(nu,rho,delta);
elseif which ==2,
  psi = psi - PsiSect(nu,rho,delta);
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
