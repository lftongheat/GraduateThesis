% Figure17: Time Frequency separation of noisy data with Homotopy

rand('state',11111);
randn('state',11111);

n = 512;
N = 2*n;
k = 40;

% Create a time-frequency dictionary
F = RSTMat(n);
I = eye(n);
A = [I F];

% Generate a random sparse vector
x0 = zeros(N, 1);
p = randperm(n);
x0(p(1:k)) = 0.8*randn(k,1);
x0(n+floor([0.45*n 0.52*n])) = [5.1 6.8];

% compute the vector y
y = A * x0;

% Add noise
SNR = 3;
z = randn(n, 1);
z = z ./ norm(z,'fro') .* (norm(y,'fro') ./ SNR);
yn = y+z;

% Solve the sparse approximation problem with ITSP
tic
[xHom, iters] = SolveLasso(A, yn, N, 'lasso', N, 0.25);
tHom = toc;

disp(['t_Hom = ' num2str(tHom), ', iters = ' num2str(iters)]);
disp(['Error = ' num2str(norm(xHom-x0,'fro')./norm(x0,'fro'))]);

figure;

subplot(2,4,1); plot(y, '-r'); 
title(['(a) Original Signal, d = ' num2str(n)]); axis([0 n -2 2]);
inz = find(x0(1:n) ~= 0);
subplot(2,4,2); stem(inz, x0(inz),'.r'); 
title('(b) Time Component'); axis([0 n -2 2]);
subplot(2,4,3); plot(A*[zeros(n,1); x0((n+1):(2*n))],'-r'); 
title('(c) Frequency Component'); axis([0 n -2 2]);
subplot(2,4,4); plot(yn, '-r'); 
title(['(d) Contaminated Signal, SNR = ' num2str(SNR)]); axis([0 n -2 2]);

subplot(2,4,5); plot(A*xHom, '-r');
title(['(e) Homotopy Solution']); axis([0 n -2 2]);
inz = find(x0(1:n) ~= 0);
subplot(2,4,6); stem(inz, xHom(inz),'.r'); 
title(['(f) Time Component of Solution']); axis([0 n -2 2]);
subplot(2,4,7); plot(A*[zeros(n,1); xHom((n+1):(2*n))],'-r'); 
title(['(g) Frequency Component of Solution']); axis([0 n -2 2]);
subplot(2,4,8); plot(yn - A*xHom, '-r');
title(['(h) Residual']); axis([0 n -2 2]);
