function xx = sample_mfa(MFA,N,noise);
%
% xx = sample_mfa(MFA,N,noise);
%
% sample N points from the mfa
%
% if noise=1 then also sample from the diagonal noise models
%
% x = sample_mfa(mfa,n);
%
% by Jakob Verbeek, Intelligent Systems Laboratory Amsterdam, University of Amsterdam, 2005.
% http://www.science.uva.nl/~jverbeek


if nargin==2; noise=0;end

[D,d,C] = size(MFA.W);

cc      = rand(N,1);
cc      = sum(cc*ones(1,C) > ones(N,1)*cumsum([0 MFA.mix(1:end-1)']) , 2);

xx = zeros(D,N);

for c=1:C;

    ii = find(cc==c);
    n  = length(ii);
    yy = 1*randn(d,n); % sample factors
    
    xx(:,ii) = MFA.M(:,c)*ones(1,n)...
             + MFA.W(:,:,c)*yy...
             + noise*spdiags(MFA.Psi(:,c).^(1/2),0,D,D)*randn(D,n);
    
end








