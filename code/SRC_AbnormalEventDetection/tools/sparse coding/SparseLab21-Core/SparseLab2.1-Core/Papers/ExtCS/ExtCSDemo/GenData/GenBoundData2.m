% Generates data for controlled L^p norm example when:
% N constant, P constant, M varies

N = [100 200]; 
P = [0.5 1];
M = 500:25:2000;
numTrials = 20;
errArray = zeros(length(P), length(M), length(N), numTrials);
Pnorm = zeros(length(P), length(M), length(Nfrac), numTrials);

for pp = 1:length(P)
    for mm = 1:length(M)
        for nn = 1:length(N)
            for jj = 1:numTrials
                % Generate Random Dictionary
                Phi = MatrixEnsemble(N(nn),M(mm));

                % Generate sparse signal
                alpha0 = GenRandVec(M(mm),P(pp));

                % generate the vector S
                S = Phi * alpha0;

                % Solve the BP problem
                alpha = SolveBP(Phi, S);

                errArray(pp,mm,nn,jj) = twonorm(alpha - alpha0);
                Pnorm(pp,mm,nn,jj) = pnorm(alpha0,P(pp));
            end
        end
    end
end

save BoundData2.mat M P N numTrials errArray Pnorm

%
% Copyright (c) 2006. Yaakov Tsaig
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
