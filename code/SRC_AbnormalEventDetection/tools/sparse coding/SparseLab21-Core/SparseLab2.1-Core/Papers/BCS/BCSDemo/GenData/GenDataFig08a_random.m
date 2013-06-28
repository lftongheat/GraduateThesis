%---------------------------------------------------------------
% This code generates Figure 8a (Random) of the following paper: 
% "Bayesian Compressive Sensing" (Preprint, 2007).
% The image used is from Sparselab.
% Coded by: Shihao Ji, ECE, Duke University
% last change: June. 12, 2007
% Caution: Time consuming... Run on cluster!
%---------------------------------------------------------------
clear all
%
total_count = 100;
dN = 1;
base = 650; % number of initial random measurements
ns   = 200; % number of additional random measurements
%
load I0.mat
qmf = MakeONFilter('Haar',1);

% Set finest, coarsest scales
j1 = 6;
j0 = ceil(j1/2);
% First, linear sampling by measuring 4^j1 coeffs
% (of scaling functions on scale 2^(-j1) x 2^(-j1)
alpha0 = FWT2_PO(I0, j0, qmf);
alpha_BCS0 = zeros(size(alpha0));
alpha_BCS0(1:2^j0,1:2^j0) = alpha0(1:2^j0,1:2^j0);
% Construct the vector theta of detail wavelet
% coeffs on scales j0 <= j < j1
theta1 = alpha0((2^j0+1):2^j1,1:2^j0);
theta2 = alpha0(1:2^j1,(2^j0+1):2^j1);
n1 = prod(size(theta1));
n2 = prod(size(theta2));
theta = [theta1(:); theta2(:)];

N = 4^j1 - 4^j0;

for count = 1:total_count
    count
    randn('state', 2*count);
    %
    Phi = randn(base,N);
    Phi = 1.01*Phi./repmat(sqrt(sum(Phi.^2,2)),[1,N]);

    % generate the vector S (random measurments of detail coeffs)
    S = Phi * theta;

    for i = 1:ns

        K = base+i*dN;
        phi = randn(dN,N);
        phi = 1.01*phi/sqrt(sum(phi.^2));

        % noisy observations
        s = phi*theta;
        S = [S;s];
        Phi = [Phi;phi];

        initsigma2 = std(S)^2/1e6;
        [weights,used] = BCS_fast_rvm(Phi,S,initsigma2,1e-8);
        alpha = zeros(N,1);
        alpha(used) = weights;
        %
        alpha_BCS = alpha_BCS0;
        alpha_BCS((2^j0+1):2^j1,1:2^j0) = reshape(alpha(1:n1), 2^j1-2^j0, 2^j0);
        alpha_BCS(1:2^j1,(2^j0+1):2^j1) = reshape(alpha(n1+1:n1+n2), 2^j1, 2^j1-2^j0);

        % Reconstruct
        I_BCS = IWT2_PO(alpha_BCS, j0, qmf);
        % compute error
        err(count,i) = twonorm(I0 - I_BCS) / twonorm(I0);

    end
    save DataFig08a_random.mat err;
    
end
%
save DataFig08a_random.mat err;
beep;
disp('Done!');

