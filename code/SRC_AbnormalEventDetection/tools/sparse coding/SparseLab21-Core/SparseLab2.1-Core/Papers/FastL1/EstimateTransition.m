function [kEst, logitCoeffs] = EstimateTransition(K,SuccessArr,numTrials,Epsilon,ConfLev)
% EstimateTransition: Estimator of phase transition using logistic regression
% Usage
%	[kEst, logitCoeffs] = EstimateTransition(K,SuccessArr,numTrials,Epsilon,ConfLev)
% Input
%	 K          2-D Array of k values
%	 SuccessArr 2-D array, with first index n, second index k. 
%               Each element specifies how many successful trials.  
%	 Epsilon    Defines the estimator's threshold. See below.
%    numTrials  Number of independent trials. 
%    ConfLev    Confidence level, default 95%
% Outputs
%   kEst        Array of 3 vectors: Estimates of k for each n, low and high
%               confidence bounds. 
%   logitCoeffs coefficients of the logistic model for each n. 
% Description
%   This function estimates
%     \hat{k}_\epsilon (d,n) = 
%       { k s.t. Y_k(d,n) was successful with prob 1-\epsilon }
% See Also
%   EstimateL0Equiv

if nargin < 5
    ConfLev = 0.95;
end

TrialsVec = numTrials .* ones(size(SuccessArr,2),1);
kEst = zeros(size(SuccessArr,1),3);
logitCoeffs = zeros(size(SuccessArr,1),2);

% Estimate the point of transition (in k) for each (d,n) instance
for ni = 1:size(SuccessArr,1)
    % Use logistic regression to fit a generalized linear model
    SuccessVec = SuccessArr(ni,:)';
    [logitCoef,dev,stats] = glmfit(squeeze(K(ni,:)),[SuccessVec TrialsVec],'binomial','logit');

    % Estimate \hat{k} using the logistic response function
    kRange = linspace(min(squeeze(K(ni,:))),max(squeeze(K(ni,:))),1000);
    [logitFit,bLo,bHi] = glmval(logitCoef,kRange,'logit',stats,ConfLev);
    [err,ki] = min(abs(logitFit - (1 - Epsilon)));
    [errLo,kiLo] = min(abs(logitFit - bLo - (1 - Epsilon)));
    [errHi,kiHi] = min(abs(logitFit + bHi - (1 - Epsilon)));
    if (err <= 0.05)
        kEst(ni,:) = [kRange(ki), kRange(kiLo), kRange(kiHi)];
    else
        if max(logitFit) < (1 - Epsilon)
            kEst(ni,:) = [kRange(1), kRange(1), kRange(1)];
        else
            kEst(ni,:) = [kRange(length(kRange)), kRange(length(kRange)), kRange(length(kRange))];
        end
    end
    logitCoeffs(ni,:) = logitCoef;
end

