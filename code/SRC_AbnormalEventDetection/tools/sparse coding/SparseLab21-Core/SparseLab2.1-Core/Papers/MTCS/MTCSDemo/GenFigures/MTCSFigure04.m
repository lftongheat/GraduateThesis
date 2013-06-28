%------------------------------------------------------------
% This code generates Figure 4 of the following paper: 
% "Multi-Task Compressive Sensing" (Preprint, 2007).
% The images used are modified from "Random-Bars", an example 
% image in Sparselab
% Coded by: Shihao Ji, ECE, Duke University
% last change: May. 15, 2007
%------------------------------------------------------------
clear all;
load bars.mat I;
%
n = 1024; % image size
qmf = MakeONFilter('Haar',1);

% Set finest, coarsest scales
j1 = 6;
j0 = ceil(j1/2);
Pstate = 4972169;
randn('state',Pstate);

% Single-task learning
for t = 1:3
    % First, linear sampling by measuring 4^j1 coeffs
    % (of scaling functions on scale 2^(-j1) x 2^(-j1)
    alpha0 = FWT2_PO(I{t}, j0, qmf);
    alpha_LIN = zeros(size(alpha0));
    alpha_LIN(1:2^j1,1:2^j1) = alpha0(1:2^j1,1:2^j1);

    % Now, do CS scheme
    % Sample 4^j0 resume coefficients (coarse-scale
    % coeffs) at scale 2^(-j0) x 2^(-j0)
    alpha_BCS = zeros(size(alpha0));
    alpha_BCS(1:2^j0,1:2^j0) = alpha0(1:2^j0,1:2^j0);

    % Construct the vector theta of detail wavelet
    % coeffs on scales j0 <= j < j1
    theta1 = alpha0((2^j0+1):2^j1,1:2^j0);
    theta2 = alpha0(1:2^j1,(2^j0+1):2^j1);
    n1 = prod(size(theta1));
    n2 = prod(size(theta2));
    theta = [theta1(:); theta2(:)];

    Mdetail = 4^j1 - 4^j0;
    Ndetail = 606;

    % Generate Random Dictionary
    Phi{t} = MatrixEnsemble(Ndetail, Mdetail, 'USE');

    % generate the vector S (random measurments of detail coeffs)
    S{t} = Phi{t} * theta;

    % Solve using Bayesian CS
    a = 1e2/std(S{t})^2; b = 1;
    tic;
    [weights,ML{t}] = mt_CS(Phi{t},S{t},a,b,1e-8);
    t_BCS(t) = toc;
    alpha = weights;
    fprintf(1,'BCS number of nonzero weights: %d\n',sum(weights~=0));
    alpha_BCS((2^j0+1):2^j1,1:2^j0) = reshape(alpha(1:n1), 2^j1-2^j0, 2^j0);
    alpha_BCS(1:2^j1,(2^j0+1):2^j1) = reshape(alpha(n1+1:n1+n2), 2^j1, 2^j1-2^j0);

    % Reconstruct
    I_LIN{t} = IWT2_PO(alpha_LIN, j0, qmf);
    I_BCS{t} = IWT2_PO(alpha_BCS, j0, qmf);
    % compute error
    E_LIN(t) = twonorm(I{t} - I_LIN{t}) / twonorm(I{t});
    E_BCS(t) = twonorm(I{t} - I_BCS{t}) / twonorm(I{t});

end

%%%%%%%%%%%%%%%%%%%%%%
% Multi-task learning
%%%%%%%%%%%%%%%%%%%%%%
a = 1e2/std([S{1};S{2};S{3}])^2; b = 1;
tic;
[weights,ML{4}] = mt_CS(Phi,S,a,b,1e-8);
tm_BCS = toc;
for t = 1:3
    alpha = weights(:,t);
    fprintf(1,'BCS number of nonzero weights: %d\n',sum(alpha~=0));

    alpha0 = FWT2_PO(I{t}, j0, qmf);
    alpha_BCS = zeros(size(alpha0));
    alpha_BCS(1:2^j0,1:2^j0) = alpha0(1:2^j0,1:2^j0);
    alpha_BCS((2^j0+1):2^j1,1:2^j0) = reshape(alpha(1:n1), 2^j1-2^j0, 2^j0);
    alpha_BCS(1:2^j1,(2^j0+1):2^j1) = reshape(alpha(n1+1:n1+n2), 2^j1, 2^j1-2^j0);

    % Reconstruct
    IM_BCS{t} = IWT2_PO(alpha_BCS, j0, qmf);
    % compute error
    EM_BCS(t) = twonorm(I{t} - IM_BCS{t}) / twonorm(I{t});
end


subplot(3,3,1); AutoImage(I_LIN{1}); title(['(a) Linear 1, n=' num2str(4^j1)]); axis off;
subplot(3,3,2); AutoImage(I_LIN{2}); title(['(b) Linear 2, n=' num2str(4^j1)]); axis off;
subplot(3,3,3); AutoImage(I_LIN{3}); title(['(c) Linear 3, n=' num2str(4^j1)]); axis off;
subplot(3,3,4); AutoImage(I_BCS{1}); title(['(d) ST 1, n=' num2str(Ndetail+4^j0)]); axis off;
subplot(3,3,5); AutoImage(I_BCS{2}); title(['(e) ST 2, n=' num2str(Ndetail+4^j0)]); axis off;
subplot(3,3,6); AutoImage(I_BCS{3}); title(['(f) ST 3, n=' num2str(Ndetail+4^j0)]); axis off;
subplot(3,3,7); AutoImage(IM_BCS{1}); title(['(g) MT 1, n=' num2str(Ndetail+4^j0)]); axis off;
subplot(3,3,8); AutoImage(IM_BCS{2}); title(['(h) MT 2, n=' num2str(Ndetail+4^j0)]); axis off;
subplot(3,3,9); AutoImage(IM_BCS{3}); title(['(i) MT 3, n=' num2str(Ndetail+4^j0)]); axis off;

for t = 1:3
    disp(['LIN: ||I_hat-I||/||I|| = ' num2str(E_LIN(t))]);
    disp(['ST: ||I_hat-I||/||I|| = ' num2str(E_BCS(t)) ', time = ' num2str(t_BCS(t)) ' secs']);
    disp(['MT: ||I_hat-I||/||I|| = ' num2str(EM_BCS(t)) ', time = ' num2str(tm_BCS/3) ' secs']);
end

save DataFig04.mat I_LIN I_BCS IM_BCS E_LIN E_BCS EM_BCS t_BCS tm_BCS Ndetail Mdetail j0 j1 ML;
disp('Done!');
