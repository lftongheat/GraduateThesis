function [ LogL, proj,lat_covs ] = ll_mfa(X,mfa,X2);
%
% function [ LogL, proj ] = mppca_gauss(X,M,W,Psi);
%
% computes log-likelihoods of X under Gaussians
% also returns the inferred latent coordinates
%
% X (D x N)     - n d-dimensional data
% mfa is a struct with the fields:
% M (D x C)     - k d-dimensional means
% W (D x d x C) - for each Gaussian q d-dim vectors
% Psi (D,C)     - diagonal noise levels

N         = size(X,2);
[D, d, C] = size(mfa.W);

proj = zeros(d,N,C);
LogL = zeros(C,N);

if nargin==2; X2 = X.^2;end

for c = 1:C    
  w             = mfa.W(:,:,c);
  psi           = mfa.Psi(:,c);
  
  psiI          = psi.^-1;
  psiIw         = repmat(psiI, 1,d) .* w;  
  lat_cov       = inv( eye(d) + w'* psiIw );

  psiI_w_xc     = psiIw' * X - repmat(psiIw'*mfa.M(:,c),1,N);
  proj(:,:,c)   = lat_cov * psiI_w_xc;

  log_det       = sum(log(psi)) - log(det(  lat_cov ));

  energy        =  -.5*( psiI'*X2 + psiI'*(mfa.M(:,c).^2)-2*(psiI.*mfa.M(:,c))'*X)  + .5 * sum( psiI_w_xc .* (lat_cov*psiI_w_xc),1) ;  

  LogL(c,:)     = energy -.5*log_det -(D/2)*log(2*pi);
  
  lat_covs(:,:,c) = lat_cov;
  
end
