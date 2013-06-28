function y = Partial1DFourierOp(mode,m,n,x,I,dim)
% The operator form of a random sampling matrix for the 
% compressed sensing problem.
% Specifically, it returns y = A(:,I)*x (mode = 1) or y = A(:,I)'*x (mode = 2),
% where A is an mxdim random sampling matrix defined as
% A = P*H*W^-1, where P is a random permutation matrix, 
% H is a fast Fourier operator, W^-1 is the inverse wavelet transform, 
% and I is a subset of the columns of A, i.e. a subset of 1:dim of length n.

% Pstate - state of random generator for P matrix
global Pstate qmf L N

if (mode == 1) % Direct operator
    % Sample subset I of columns
    u = zeros(dim, 1);
    u(I) = x;

    % Apply the inverse Wavelet transform
    U = IWT_PO(u, L, qmf);
    
    % Compute the (real) Fourier transform
    V = RST(U);
    
    % Sample at random
    V = V(:);
    rand('state', Pstate);
    p = randperm(dim);
    y = V(p(1:m));
    
else % Adjoint operator
    % Apply matrix P^T
    rand('state', Pstate);
    p = randperm(dim);
    x2 = zeros(dim,1);
    x2(p(1:m)) = x;

    % Compute the (real) inverse Fourier Transform
    V = Inv_RST(x2);
    
    % Apply the wavelet transform
    V = FWT_PO(V, L, qmf);
    
    % Take a subset I of the columns
    V = V(:);
    y = V(I);
end

