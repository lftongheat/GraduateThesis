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

%psi_old = Psi1 - Psi2 - Psi3;
%psi_new = Psi1 - log(2)*(1-rho.*delta);
%psi=min(psi_old,psi_new);
%if psi_new<psi_old
%display('Using the new PsiNet');
%end

%plot(psi_old)
%pause
%plot(psi_new)
%pause
%plot(psi)
%pause

if which ==3,
  psi = psi - PsiFace(nu,rho,delta);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%the below have not been modified
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
