%   3: QQ plot comparing MAI with Gaussian distribution.
% Top row: USE
% Middle row: RSE
% Bottom row: URP

N = 1024;
n = 256;
rand('state',415182372);
randn('state',6504972169);

% Generate a vector of random samples from N(0,1/n)
zn = normrnd(0,1/n,N,1);

kArr = [32, 48, 64];
col1Arr = ['(a) USE, '; '(b) RSE, '; '(c) URP, '];
col2Arr = ['(d) USE, '; '(e) RSE, '; '(f) URP, '];
col3Arr = ['(g) USE, '; '(h) RSE, '; '(i) URP, '];

pp = 1;

for ki = 1:length(kArr);
    k = kArr(ki);

    % Generate a sparse vector with k nonzeros
    x = SparseVector(N, k, 'UNIFORM', true);

    % Generate a random matrix A from the USE
    A = MatrixEnsemble(n,N,'USE');
    y = A*x;

    % Compute the matched filter result
    x_tilde = A'*y;

    % Compute the MAI
    z = x - x_tilde;
    z = z ./ norm(z);

    % Show qq plot versus N(0,1/n)
    subplot(3,3,pp); qqplot(z,zn);
    axis([-0.1 0.1 -0.015 0.015]);
    xlabel('N(0,1/n)'); ylabel('z');
    title([col1Arr(ki,:) 'k = ' num2str(k,2)]);

    % Generate a random matrix A from the RSE
    A = MatrixEnsemble(n,N,'RSE');
    y = A*x;

    % Compute the matched filter result
    x_tilde = A'*y;

    % Compute the MAI
    z = x - x_tilde;
    z = z ./ norm(z);

    % Show qq plot versus N(0,1/n)
    subplot(3,3,pp+1); qqplot(z,zn);
    axis([-0.1 0.1 -0.015 0.015]);
    xlabel('N(0,1/n)'); ylabel('z');
    title([col2Arr(ki,:) 'k = ' num2str(k,2)]);

    % Generate a random matrix A from the URP
    A = MatrixEnsemble(n,N,'URP');
    y = A*x;

    % Compute the matched filter result
    x_tilde = A'*y;

    % Compute the MAI
    z = x - x_tilde;
    z = z ./ norm(z);

    % Show qq plot versus N(0,1/n)
    subplot(3,3,pp+2); qqplot(z,zn);
    axis([-0.1 0.1 -0.015 0.015]);
    xlabel('N(0,1/n)'); ylabel('z');
    title([col3Arr(ki,:) 'k = ' num2str(k)]);

    pp = pp+3;
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

