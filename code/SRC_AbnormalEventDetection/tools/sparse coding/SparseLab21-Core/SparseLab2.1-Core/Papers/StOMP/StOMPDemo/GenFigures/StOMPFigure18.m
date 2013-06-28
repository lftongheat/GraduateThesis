% Figure 18: Time Frequency separation with StOMP

rand('state',12345);
randn('state',98765);

n = 512;
N = 2*n;
k = 32;
delta = n/N;
S = 10;
a_0 = delta .* (1-k/(delta.*n)) ./ S;
q = min((delta.*n - k)./k,0.5);

% Create a time-frequency dictionary
F = RSTMat(n);
I = eye(n);
A = [I F];

% Generate a random sparse vector
x0 = zeros(N, 1);
p = randperm(n);
x0(p(1:k)) = 0.5*randn(k,1);
x0(n+floor([0.45*n 0.52*n])) = [5.1 6.8];

% compute the vector y
y = A * x0;

% Solve the sparse approximation problem with ITSP
tic
[xFAR, iters] = SolveStOMP(A, y, N, 'FAR', a_0, S, 1);
tFAR = toc;

tic
[xFDR, iters] = SolveStOMP(A, y, N, 'FDR', q, S, 1);
tFDR = toc;

disp(['t_FAR = ' num2str(tFAR) ', t_FDR = ' num2str(tFDR)]);

figure;

subplot(3,3,1); plot(y, '-r'); 
title(['(a) Original Signal, n = ' num2str(n)]); axis([0 n -1.5 1.5]);
inz = find(x0(1:n) ~= 0);
subplot(3,3,2); stem(inz, x0(inz),'.r'); 
title('(b) Time Component'); axis([0 n -1.5 1.5]);
subplot(3,3,3); plot(A*[zeros(n,1); x0((n+1):(2*n))],'-r'); 
title('(c) Frequency Component'); axis([0 n -1.5 1.5]);

subplot(3,3,4); plot(A*xFAR, '-r');
title(['(d) CFAR Solution']); axis([0 n -1.5 1.5]);
inz = find(x0(1:n) ~= 0);
subplot(3,3,5); stem(inz, xFAR(inz),'.r'); 
title(['(e) Time Component of CFAR Solution']); axis([0 n -1.5 1.5]);
subplot(3,3,6); plot(A*[zeros(n,1); xFAR((n+1):(2*n))],'-r'); 
title(['(e) Frequency Component of CFAR Solution']); axis([0 n -1.5 1.5]);

subplot(3,3,7); plot(A*xFDR, '-r');
title(['(f) CFDR Solution']); axis([0 n -1.5 1.5]);
inz = find(x0(1:n) ~= 0);
subplot(3,3,8); stem(inz, xFDR(inz),'.r'); 
title(['(g) Time Component of CFDR Solution']); axis([0 n -1.5 1.5]);
subplot(3,3,9); plot(A*[zeros(n,1); xFDR((n+1):(2*n))],'-r'); 
title(['(h) Frequency Component of CFDR Solution']); axis([0 n -1.5 1.5]);


%
% Copyright (c) 2006. David Donoho, Iddo Drori, and Yaakov Tsaig
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
