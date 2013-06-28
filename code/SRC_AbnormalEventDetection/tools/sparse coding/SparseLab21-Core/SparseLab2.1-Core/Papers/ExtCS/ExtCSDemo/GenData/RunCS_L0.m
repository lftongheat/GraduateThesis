% This program solves the following BP problem
% Min  || alpha ||_1 s.t. Phi*alpha = S
% where Phi is a random dictionary, and alpha is a sparse vector.
% Used by: GenData_L0

% Global Variables: 
%   M - signal dimension
%   K - number of nonzeros

N = floor(M ./ 32):16:(M ./ 2);
E = zeros(1, length(N));

% Generate sparse signal
alpha0 = [ones(K,1); zeros(M-K,1)];

for jj = 1:length(N)
    E(jj) = 0;
    for kk = 1:20
        % Generate Random Dictionary
        Phi = MatrixEnsemble(N(jj),M);
        
        % generate the vector S
        S = Phi * alpha0;
        
        % Solve the BP problem
        alpha = SolveBP(Phi, S, size(Phi,2), 5);
        
        % Compute & store the error in the reconstruction
        E(jj) = E(jj) + twonorm(alpha - alpha0) ./ twonorm(alpha0);
    end
    E(jj) = E(jj) ./ 10;
end

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
