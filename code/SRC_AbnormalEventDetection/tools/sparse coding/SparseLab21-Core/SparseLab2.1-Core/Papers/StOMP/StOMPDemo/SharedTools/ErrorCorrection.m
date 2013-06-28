% Error-Correcting Codes with StOMP.

n = 2^8;
k = floor(0.1*n);
delta = 3/4;
len = floor((1-delta).*n);
sigma_z = 1;
S = 10;
a_0 = delta .* (1-k/(delta.*n)) ./ S;
q = min((delta.*n - k)./k,0.5);

% Create digital signal to be encoded
theta = SparseVector(len,len,'Signs');

% Create encoding matrix
G = randn(n);
[Q,R] = qr(G);
B = Q(:,1:len);
A = Q(:,(len+1):n)';

% Encoding stage
tx = B*theta;

% Transmission stage: Add sparse noise
z = SparseVector(n,k,'Gaussian',1) .* sigma_z;
rx = tx+z;

% Decoding stage: Solve with ITSP
y = A*rx;

tic
[xFAR, iters] = SolveStOMP(A, y, n, 'FAR', a_0, S, 1);
tFAR = toc;
thetaFAR = sign(B'*(rx-xFAR));
BER_FAR = sum(thetaFAR ~= theta) ./ len;

tic
[xFDR, iters] = SolveStOMP(A, y, n, 'FDR', q, S, 1);
tFDR = toc;
thetaFDR = sign(B'*(rx-xFDR));
BER_FDR = sum(thetaFDR ~= theta) ./ len;

disp(['t_FAR = ' num2str(tFAR) ', t_FDR = ' num2str(tFDR)]);

figure; 
subplot(3,1,1); stem(theta,'.r'); 
title(['(a) Transmitted signal \theta, n = ' num2str(len)]);
axis([1 len -1.5 1.5]);

subplot(3,1,2); stem(thetaFAR,'.r'); 
title(['(b) Decoded with CFAR, BER = ' num2str(BER_FAR,3)]);
axis([1 len -1.5 1.5]);

subplot(3,1,3); stem(thetaFDR,'.r'); 
title(['(c) Decoded with CFDR, BER = ' num2str(BER_FDR,3)]);
axis([1 len -1.5 1.5]);

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
