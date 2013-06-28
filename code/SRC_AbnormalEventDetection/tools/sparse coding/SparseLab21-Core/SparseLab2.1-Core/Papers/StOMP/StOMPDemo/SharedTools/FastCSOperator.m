function y = FastCSOperator(mode,m,n,x,I,dim)
% FastCSOperator: The operator form of a random sampling matrix for the 
% compressed sensing problem.
% Specifically, it returns y = A(:,I)*x (mode = 1) or y = A(:,I)'*x (mode = 2),
% where A is an mxdim random sampling matrix defined as
% A = P*H*Q, where P,Q are random permutation matrices, 
% H is a fast Hadamard/Fourier operator, and I is 
% a subset of the columns of A, i.e. a subset of 1:dim of length n.

% Pstate - state of random generator for P matrix
% Qstate - state of random generator for Q matrix
Pstate = 4972169;
Qstate = 7256157;

if (mode == 1) % Direct operator
    % Sample subset I of columns
    u = zeros(dim, 1);
    u(I) = x;
    
    % Apply matrix Q
    rand('state', Qstate);
    q = randperm(dim);
    u2 = u(q);
    
    % Apply matrix H
    u3 = RST(u2);
    % Uncomment for Hadamard
    %u3 = FHT(u2);
    
    % Apply matrix P
    rand('state', Pstate);
    p = randperm(dim);
    y = u3(p(1:m));
    
else % Adjoint operator
    % Apply matrix P^T
    rand('state', Pstate);
    p = randperm(dim);
    x2 = zeros(dim,1);
    x2(p(1:m)) = x;

    % Apply matrix H^T
    x3 = Inv_RST(x2);
    % Uncomment for Hadamard
    %u3 = Inv_FHT(u2);
    
    % Apply matrix Q^T
    rand('state', Qstate);
    q = randperm(dim);
    x4 = zeros(dim,1);
    x4(q) = x3;
    
    y = x4(I);
end

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

