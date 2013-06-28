% Use partial discrete Walsh-Hadamart transform matrix
% (see function Utilities/pdwht_operator.m)
%
% Use DCT as sparsifying basis 
% (requires signal processing toolbox)

clear;
if ~exist('pdwht_operator','file'); Run_Me_1st; end

% problem sizes 
n = 1024*8;     % must be a power of 2
m = n/8; k = m/8; 
fprintf('[n,m,k] = [%i,%i,%i]\n',n,m,k);

% generate xs (non-sparse)
xs = cumsum(randn(n,1)); 

% A = partial DWHT matrix
p = randperm(n);
picks = sort(p(1:m),'ascend'); picks(1) = 1;
A = pdwht_operator(picks,randperm(n));

% b = A*xs + noise
sigma = 0.01;    % noise level
b = A.times(xs) + sigma*randn(m,1);

% set options
opts.tol = 5e-3;
opts.rho = 5e-5;
opts.basis.times = @(x)  dct(x);    % sparsfying basis
opts.basis.trans = @(x) idct(x);    % inverse of basis

% call YALL1
tic; [x,Out] = yall1(A, b, opts); toc
relerr = norm(x-xs)/norm(xs);
fprintf('iter = %4i, error = %e\n',Out.iter,relerr)
plot(1:n,xs,'b-',1:n,x,'r:'); 
legend('Original','Recovered','location','best')