%-------------------------------------------------------------------
% This code generates Figure 5a (Random OMP) of the following paper: 
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
ns   = 80; % number of additional random measurements
sigma = 0.005;
%
for count = 1:total_count
    count
    rand('state', count);
    randn('state', 2*count);
    %
    % random +/- 1 signal
    x = zeros(N,1);
    q = randperm(N);
    x(q(1:T)) = sign(randn(T,1));
    % noisy observations
    A = randn(base,N);
    A = 1.01*A./repmat(sqrt(sum(A.^2,2)),[1,N]);
    e = sigma*randn(base,1);
    y = A*x + e;

    for i = 1:ns
        
        K = base+i*dN;
        a = randn(dN,N);
        a = 1.01*a/sqrt(sum(a.^2));
        % noisy observations
        e = sigma*randn(dN,1);
        t = a*x + e;
        y = [y;t];
        A = [A;a];
        %
        xp = SolveOMP(A,y,N,30,1e-6,0,0,1e-8);
        %
        err(count,i) = norm(x-xp)/norm(x);
         
    end
    
end
%
save DataFig05a_random.mat err;
beep;
disp('Done!');
