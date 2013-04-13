function	[Q, LogL, Lats, lat_covs] = mfa_E_step(X,mfa,X2); % E-step
%
% [Q, LogL, Lats, lat_covs] = mfa_E_step(X,mfa,X2); % E-step
%

N       = size(X,2);
[D,d,C] = size(mfa.W);

if nargin<3; X2=X.^2;end

[LogPxGc, Lats, lat_covs] = ll_mfa(X,mfa,X2);

LogPxc = LogPxGc + log(mfa.mix+realmin)*ones(1,N);

Q    = LogPxc - repmat(max(LogPxc,[],1),C,1);
Q    = exp(Q)+realmin;
Q    = Q ./ repmat(sum(Q,1),C,1);

LogL = sum(Q.*(-log(Q+realmin) + LogPxc),1);
