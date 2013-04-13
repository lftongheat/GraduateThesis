function [LogL,MoFA,Q] = mfa(X,d,C,iso,eq,dia);
%
% [LogL,mfa,Q] = mfa(X,d,C,iso,dia);
% 
% X     : data matrix (N data points in D dimensions as columns)
% d     : latent dimensionality
% C     : number of mixtuer components
% iso   : use isotropic noise if 1
% eq    : use equal noise model for all components
% dia   : verbosity. 0=no output, 1=log-likelihood monitoring, 2=posterior plotting
%
% LogL  : row vector of log-likelihoods after each EM iteration
% MoFA  : structure containing the Mixture of Factor Analyzers
%         MoFA.W (D x d x C) : factor loading matrices
%         MoFA.M (D x C)     : component means
%         MoFA.Psi ( D x C ) : component noise variances
%         MoFA.mix ( C x 1 ) : mixing weights
% Q     : C x N matrix of component posterior probabilities
%
% by Jakob Verbeek, Intelligent Systems Laboratory Amsterdam, University of Amsterdam, 2005.
% http://www.science.uva.nl/~jverbeek

epsilon       = 1e-3;                                       % relative log-likelihood increase threshold for convergence
max_iters     = 1000;                                       % maximum number of EM iterations
min_iters     = 10;                                         % minimum number of EM iterations

[D,N]         = size(X); 

if dia
    fprintf('--> running EM for MoFA\n');
	fprintf('    mixture components: %d\n',C);
	fprintf('    latent dimensions : %d\n',d);
	fprintf('    data: %d points in %d dimensions\n',N,D);
	if iso; fprintf('    using isotropic noise model\n');end
    if eq;  fprintf('    equal noise model in components\n');end
end

% --------   Initialisation
MoFA.mix   = ones (C,1)/C;                                  % mixing weights
MoFA.M     = randperm(N); MoFA.M     = X(:,MoFA.M(1:C));    % means
MoFA.Psi   = 100*var(X(:))*ones(D,C);                       % noise variance
MoFA.W     = randn(D,d,C);                                  % factor loadings

X2 = X.^2;

for iter=1:max_iters; % EM loops

	[Q, LL,Lats, lat_covs] = mfa_E_step(X,MoFA,X2);         % E-step
    LogL(iter) = sum(LL);
	MoFA = mfa_M_step(X,X2,Q,Lats,lat_covs,iso,eq);         % M-step

    if iter > 1;
        rel_change = (LogL(end)-LogL(end-1)) / abs(mean(LogL(end-1:end)));
        if rel_change < 0; fprintf('--> Log likelihood decreased in iteration %d,  relative change %f\n',iter,rel_change);end
        if dia; fprintf('iteration %3d   Logl %.2f  relative increment  %.6f\n',iter, LogL(end),rel_change);end
        if dia>1; clf;set(gcf,'Double','on');imagesc(Q);xlabel('data point index');ylabel('mixture component index');set(gca,'ytick',1:C);colormap gray;colorbar;title('Posterior distributions on mixture components given data point');drawnow;end    
        if (rel_change < epsilon) & (iter > min_iters); break;end
    end
    
end
