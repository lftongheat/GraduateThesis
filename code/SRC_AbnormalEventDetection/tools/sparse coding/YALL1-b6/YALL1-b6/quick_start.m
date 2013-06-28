clear;
if ~exist('Utilities','dir'); Run_Me_1st; end

% problem sizes 
n = 1000; m = 300; k = 15; 
sigma = 0.00;

% generate (A,xs,b) 
A = randn(m,n);
xs = zeros(n,1);
p = randperm(n);
xs(p(1:k)) = randn(k,1);
b = A*xs + sigma*randn(m,1); 

% (orth)normalize the rows of A
if ~exist('nonorth','var'); 
    nonorth = randn > 0; 
end

if nonorth;
    d = 1./sqrt(sum(A.^2,2));
    A = sparse(1:m,1:m,d)*A;
    b = d.*b;
else
    [Q, R] = qr(A',0);
    A = Q'; b = R'\b;
end

% call YALL1
opts.tol = 5e-8;
if sigma > 0;
    opts.tol = 5e-3;
    opts.rho = sigma;
end
opts.print = 0;
[x,Out] = yall1(A, b, opts); 
fprintf('nonorth: %i, iter = %4i, error = %e\n',...
    nonorth,Out.iter,norm(x-xs)/norm(xs))
