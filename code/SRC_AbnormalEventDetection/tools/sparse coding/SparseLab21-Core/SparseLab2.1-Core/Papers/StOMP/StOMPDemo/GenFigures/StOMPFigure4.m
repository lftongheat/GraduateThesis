% Figure 4: Q-Q plots Comparing MAI for CFAR iterate with 
% Gaussian distribution.

N = 1024;
n = 256;
k = 64;

rand('state',415182372);
randn('state',6504972169);

plotArr = ['(a)'; '(b)'; '(c)'; '(d)'; '(e)'; '(f)'];

% Generate a sparse vector with k nonzeros
x = SparseVector(N, k, 'UNIFORM', true);

% Generate a random matrix A from USE
A = MatrixEnsemble(n,N,'USE');
y = A*x;

% Run ITSP with CFAR thresholding
delta = n/N;
rho = k/n;
S = 6;
alpha_0 = delta*(1-rho)/S;
[sol, numIters] = SolveStOMP(A, y, N, 'FAR', alpha_0, S);

% with plots
thr = norminv(1 - alpha_0/2, 0, 1);
res = y;
activeSet = [];

for iter = 1:S
    % Ansatz check
    inactiveSet = setdiff(1:N, activeSet);
    asz = (A(:,inactiveSet)'*res ...
        ./ (1 - length(activeSet)./N) - x(inactiveSet));
    cn = sqrt(n) ./ norm(asz,'fro');
    asz = asz .* cn;
    disp(['c_{n,' num2str(iter) '} = ' num2str(cn)]);
    
    % Compute matched filter output
    resnorm = norm(res);
    x_tilde = A'*res;
    corr = sqrt(n) .* x_tilde ./ resnorm;

    % Do FAR thresholding
    I = find(abs(corr) > thr);
    activeSet = union(activeSet, I);

    % Compute current estimate and residual
    x_I = A(:,activeSet) \ y;
    res = y - A(:,activeSet)*x_I;

    subplot(2,3,iter); qqplot(asz);
    xlabel('N(0,1)'); ylabel('z');
    axis([-4 4 -2 2]);
    title([plotArr(iter,:) ' Iteration no. ' num2str(iter)]);

    fprintf('Iteration %d: |I| = %d, ||r||_2 = %g\n', iter, length(activeSet), norm(res));
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


