%-------------------------------------------------------------------
% This code generates Figure 5b (Approx. OMP) of the following paper: 
% "Bayesian Compressive Sensing" (Preprint, 2007).
% The dataset used is similar to the one used in l1qc_example.m,
% an example from l1magic.
% Coded by: Shihao Ji, ECE, Duke University
% last change: June. 12, 2007
%-------------------------------------------------------------------
clear all
%
total_count = 100;
N  = 512; % signal length
T  = 20;  % number of spikes
dN = 1;
base = 40; % number of initial random measurements
ns   = 80; % number of additional measurements
sigma = 0.005;
scale = 0.1;
%
for count = 1:total_count
    count
    rand('state', count);
    randn('state', 2*count);
    %
    % random +/- 1 signal
    x = zeros(N,1);
    q = randperm(N);
    amp = randn(T,1);
    x(q(1:T)) = amp*sqrt(T/sum(amp.^2)); % re-scaled to have the same SNR as in Fig.2
    % noisy observations
    A = randn(base,N);
    A = 1.01*A./repmat(sqrt(sum(A.^2,2)),[1,N]);
    e = sigma*randn(base,1);
    y = A*x + e;
    %
    [xp, iters, used] = SolveOMP(A, y, N,30,1e-6,0,0,1e-8);
    % Approx. Adaptive CS
    phi = A(:,used);
    temp = phi'*phi;
    Sig_inv = temp + scale*mean(diag(temp))*eye(length(used));
    [V,D] = eig(Sig_inv);
    [foo,idx] = min(diag(D));
    basis = V(:,idx)';

    for i = 1:ns

        K = base+i*dN;
        a = randn(dN,N);
        unused = setdiff([1:N],used);
        a(unused) = sqrt(1.01^2-1)*a(unused)/sqrt(sum(a(unused).^2)); % noise imputation
        a(used) = basis;
        % noisy observations
        e = sigma*randn(dN,1);
        t = a*x + e;
        y = [y;t];
        A = [A;a];
        %
        [xp, iters, used] = SolveOMP(A, y, N,30,1e-6,0,0,1e-8);
        % Approx. Adaptive CS
        phi = A(:,used);
        temp = phi'*phi;
        Sig_inv = temp + scale*mean(diag(temp))*eye(length(used));
        [V,D] = eig(Sig_inv);
        [foo,idx] = min(diag(D));
        basis = V(:,idx)';
     
        err(count,i) = norm(x-xp)/norm(x);
        
    end

end
%
save DataFig05b_approx.mat err;
beep;
disp('Done!');
