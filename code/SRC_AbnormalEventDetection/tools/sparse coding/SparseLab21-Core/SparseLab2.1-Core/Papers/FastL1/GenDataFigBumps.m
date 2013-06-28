% GenDataFigBumps: Generate simulation data for figure 15: CS reconstruction 
% of `Bumps' with Homotopy, Lars, OMP and PFP.

N = 1024;
n = 512;

x0 = MakeBumps(N)';
qmf = MakeONFilter('Symmlet',8); 
L = 3;

% Pstate - state of random generator for P matrix
Pstate = 987654321;

iterArr = [100 200 N];
xHom = zeros(length(iterArr), length(x0));
xLARS = zeros(length(iterArr), length(x0));
xOMP = zeros(length(iterArr), length(x0));
xPFP = zeros(length(iterArr), length(x0));
tHom = zeros(size(iterArr));
tLARS = zeros(size(iterArr));
tOMP = zeros(size(iterArr));
tPFP = zeros(size(iterArr));
errHom = zeros(size(iterArr));
errLARS = zeros(size(iterArr));
errOMP = zeros(size(iterArr));
errPFP = zeros(size(iterArr));

% Create Partial Fourier Matrix
rand('state', Pstate);
A = MatrixEnsemble(n,N,'RST');

% Sample Fourier coeffs at random
alpha0 = FWT_PO(x0, L, qmf);
y = A*alpha0;

for ii = 1:length(iterArr)
    disp(['Iteration ' num2str(ii)]);
    
    tic
    % Solve the CS problem with Lasso
    [alpha, iters] = SolveLasso(A, y, N, 'lasso', iterArr(ii));
    tHom(ii) = toc;
    xHom(ii,:) = IWT_PO(alpha, L, qmf);
    errHom(ii) = norm(xHom(ii,:)-x0.') ./ norm(x0);
    
    tic
    % Solve the CS problem with Lars
    [alpha, iters] = SolveLasso(A, y, N, 'lars', iterArr(ii));
    tLARS(ii) = toc;
    xLARS(ii,:) = IWT_PO(alpha, L, qmf);
    errLARS(ii) = norm(xLARS(ii,:)-x0.') ./ norm(x0);
    
    tic
    % Solve the CS problem with OMP
    [alpha, iters] = SolveOMP(A, y, N, iterArr(ii));
    tOMP(ii) = toc;
    xOMP(ii,:) = IWT_PO(alpha, L, qmf);
    errOMP(ii) = norm(xOMP(ii,:)-x0.') ./ norm(x0);

    tic
    % Solve the CS problem with PFP
    [alpha, iters] = SolvePFP(A, y, N, 'pfp', iterArr(ii));
    tPFP(ii) = toc;
    xPFP(ii,:) = IWT_PO(alpha, L, qmf);
    errPFP(ii) = norm(xPFP(ii,:)-x0.') ./ norm(x0);
    
    disp(['tHom = ' num2str(tHom(ii)) ', tLars = ' num2str(tLARS(ii)) ...
          ', tOMP = ' num2str(tOMP(ii)) ', tPFP = ' num2str(tPFP(ii))]);
end

clear x0 alpha alpha0 qmf A F
save DataFigBumps.mat
 
