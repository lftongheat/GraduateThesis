% Figure 2: Evolution of StOMP approximation with CFAR thresholding.
% Panels (a),(d),(g): successive matched filtering outputs
% $\tilde{x}_1$,$\tilde{x}_2$, $\tilde{x}_3$;
% Panels (b),(e),(h): successive thresholding results;
% Panels (c),(f),(i): successive partial solutions.

N = 1024;
n = 256;
k = 32;

rand('state',415182372);
randn('state',6504972169);

col1Arr = ['(a)'; '(d)'; '(g)'];
col2Arr = ['(b)'; '(e)'; '(h)'];
col3Arr = ['(c)'; '(f)'; '(i)'];

% Generate a sparse vector with k nonzeros with uniform distribution
x = SparseVector(N, k, 'UNIFORM', true);

% Generate a random matrix A from USE
A = MatrixEnsemble(n,N,'USE');
y = A*x;

% Run StOMP with CFAR thresholding
delta = n/N;
rho = k/n;
S = 3;
alpha_0 = delta*(1-rho)/S;
[sol, numIters] = SolveStOMP(A, y, N, 'FAR', alpha_0, S); % rerun below

% with plots
thr = norminv(1 - alpha_0/2, 0, 1);
res = y;
activeSet = [];
plotNum = 1;

for iter = 1:S
    % Compute matched filter output
    resnorm = norm(res);
    x_tilde = A'*res;
    corr = sqrt(n) .* x_tilde ./ resnorm;

    % Do FAR thresholding
    I = find(abs(corr) > thr);
    x_hat = zeros(N,1);
    x_hat(I) = corr(I) ./ sqrt(n) .* resnorm;
    activeSet = union(activeSet, I);

    % Compute current estimate and residual
    x_I = A(:,activeSet) \ y;
    x_s = zeros(N,1);
    x_s(activeSet) = x_I;
    res = y - A(:,activeSet)*x_I;

    subplot(3,3,plotNum); plot(1:N,x_tilde);
    axis([1 N -1 1]);
    title([col1Arr(iter,:) ' Matched filtering']);
    
    subplot(3,3,plotNum+1); plot(1:N,x_hat);
    axis([1 N -1 1]);
    title([col2Arr(iter,:) ' Hard thresholding']);

    subplot(3,3,plotNum+2); plot(1:N,x_s);
    axis([1 N -1 1]);
    title([col3Arr(iter,:) ' Approximate solution x_{' num2str(iter,3) '}, ||x_{' ... 
        num2str(iter,3) '} - x_{0}||_{2} = ' num2str(norm(x_s - x)./norm(x),2)]);

    plotNum = plotNum+3;
end


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


bv