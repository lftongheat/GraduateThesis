%---------------------------------------------------------------
% This code generates Figure 8b (Random) of the following paper: 
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
base = 100;
ns   = 500; % number of additional random measurements
%
I0 = imread('Mondrian.tif');
I0 = double(I0);
qmf = MakeONFilter('Symmlet',8);

% Set finest, coarsest scales
j1 = 6;
j0 = 4;

% Do Multi-CS scheme:
% Sample 4^j0 resume coefficients (coarse-scale
% coeffs) at scale 2^(-j0) x 2^(-j0)
alpha0 = FTWT2_PO(I0, j0, qmf);
alpha_BCS0 = zeros(size(alpha0));
alpha_BCS0(1:2^j0,1:2^j0) = alpha0(1:2^j0,1:2^j0);

for count = 1:total_count
    count
    randn('state', 2*count);
    %
    % For each scale, apply CS scheme
    jj = 5;
    % Construct the vector theta of detail wavelet
    % coeffs on scale jj
    theta1 = alpha0((2^jj+1):2^(jj+1),1:2^jj);
    theta2 = alpha0(1:2^(jj+1),(2^jj+1):2^(jj+1));
    n1 = prod(size(theta1));
    n2 = prod(size(theta2));
    theta = [theta1(:); theta2(:)];

    Mdetail = 4^(jj+1) - 4^jj;
    Ndetail = floor(0.6*Mdetail);
    N_CS = 4^j0 + base + Ndetail;

    % Sample Ndetail compressed samples using the CS operator
    Phi = randn(Ndetail,Mdetail);
    Phi = 1.01*Phi./repmat(sqrt(sum(Phi.^2,2)),[1,Mdetail]);
    S = Phi * theta;

    % Bayesian CS
    initsigma2 = std(S)^2/1e2;
    [weights,used] = BCS_fast_rvm(Phi,S,initsigma2,1e-8);
    alpha = zeros(Mdetail,1);
    alpha(used) = weights;
    alpha_BCS0((2^jj+1):2^(jj+1),1:2^jj) = reshape(alpha(1:n1), 2^(jj+1)-2^jj, 2^jj);
    alpha_BCS0(1:2^(jj+1),(2^jj+1):2^(jj+1)) = reshape(alpha(n1+1:n1+n2), 2^(jj+1), 2^(jj+1)-2^jj);

    % For each scale, apply CS scheme
    jj = 4;
    % Construct the vector theta of detail wavelet
    % coeffs on scale jj
    theta1 = alpha0((2^jj+1):2^(jj+1),1:2^jj);
    theta2 = alpha0(1:2^(jj+1),(2^jj+1):2^(jj+1));
    n1 = prod(size(theta1));
    n2 = prod(size(theta2));
    theta = [theta1(:); theta2(:)];

    N = 4^(jj+1) - 4^jj;
    % Sample Ndetail compressed samples using the CS operator
    Phi = randn(base,N);
    Phi = 1.01*Phi./repmat(sqrt(sum(Phi.^2,2)),[1,N]);
    S = Phi * theta;

    for i = 1:ns

        K = base+i*dN;
        phi = randn(dN,N);
        phi = 1.01*phi/sqrt(sum(phi.^2));
        % noisy observations
        s = phi*theta;
        S = [S;s];
        Phi = [Phi;phi];
        %
        initsigma2 = std(S)^2/1e2;
        [weights,used] = BCS_fast_rvm(Phi,S,initsigma2,1e-8);
        alpha = zeros(N,1);
        alpha(used) = weights;
        alpha_BCS = alpha_BCS0;
        alpha_BCS((2^jj+1):2^(jj+1),1:2^jj) = reshape(alpha(1:n1), 2^(jj+1)-2^jj, 2^jj);
        alpha_BCS(1:2^(jj+1),(2^jj+1):2^(jj+1)) = reshape(alpha(n1+1:n1+n2), 2^(jj+1), 2^(jj+1)-2^jj);

        % Reconstruct
        I_BCS = ITWT2_PO(alpha_BCS, j0, qmf);
        % compute error
        err(count,i) = norm(I0 - I_BCS,'fro') / norm(I0,'fro');

    end
    save DataFig08b_random.mat err N_CS;
    
end
save DataFig08b_random.mat err N_CS;
beep;
disp('Done!');

