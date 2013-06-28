% Figure 4: CS reconstruction of a signal with controlled L^p norm.

M = 1000;
N = 100;
P = 0.75;

% Generate Random Dictionary
Phi = MatrixEnsemble(N,M);

% Generate sparse signal
alpha0 = GenRandVec(M,P);

% generate the vector S
S = Phi * alpha0;

% Solve the BP problem
alpha = SolveBP(Phi, S, size(Phi,2), 5);

E = twonorm(alpha - alpha0);

subplot(2,1,1);
plot(alpha0); 
title(['Original Signal, m = ' num2str(M)]);

subplot(2,1,2);
plot(alpha,'-r');
title(['CS Reconstruction, n = ' num2str(N) ', || x_{1,n} - x_{0} ||_{2} = ' num2str(E,3)]);


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
