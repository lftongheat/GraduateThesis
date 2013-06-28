% GenDataFigMRI: Create simulation data for Figure 16: CS reconstruction 
% of a 3-D MRI volume from partial Fourier information.

ratio = 0.5;
MaxIters = 2000;
solFreq = 400;
writeFreq = 5;

fIn = 'MRI3D.mat';
fOut = 'MRI3D-Recon.mat';
istart = 1;
iend = 240;

load(fIn);
numMarks = MaxIters / solFreq;
LarsCSArr = zeros([numMarks, size(ImgArr)]);
OMPCSArr = zeros([numMarks, size(ImgArr)]);
BPCSArr = zeros(size(ImgArr));

%istart = 1;
if (exist(fOut))
    load(fOut);
    istart = ii+1;
end

% Pstate - state of random generator for P matrix
global Pperm qmf L N

N = size(ImgArr,1);
Pstate = 4972169;
rand('state', Pstate);
Pperm =  randperm(N*N);

qmf = MakeONFilter('Symmlet',8); 
L = 3;

for ii = istart:iend%size(ImgArr,3)
    disp([fIn ': Iteration ' num2str(ii)]);
    
    I0 = squeeze(ImgArr(:,:,ii));
    alpha0 = FWT2_PO(I0, L, qmf);
    alpha0 = alpha0(:);
    n = length(alpha0);
    d = floor(ratio .* n);
    
    % Sample Fourier coeffs at random
    y = PartialFourierOp(1,d,n,alpha0,1:n,n);

    tic
    % Solve the CS problem with Lasso
    [solsLars, iters] = SolveLasso('PartialFourierOp', y, n, 'lars', MaxIters, solFreq);
    tLars = toc;
    
    tic
    % Solve the CS problem with OMP
    [solsOMP, iters] = SolveOMP('PartialFourierOp', y, n, MaxIters, solFreq);
    tOMP = toc;

    tic
    % Solve the CS problem with BP
    solsBP = SolveBP('PartialFourierOp', y, n, 15, 1e-2);
    tBP = toc;

    % Reconstruct
    for jj = 1:numMarks
        LarsCSArr(jj,:,:,ii) = reshape(IWT2_PO(reshape(solsLars(:,min(jj,size(solsLars,2))),[N N]), L, qmf), [1, N, N, 1]);
        OMPCSArr(jj,:,:,ii) = reshape(IWT2_PO(reshape(solsOMP(:,min(jj,size(solsOMP,2))),[N N]), L, qmf), [1, N, N, 1]);
    end
    BPCSArr(:,:,ii) = reshape(IWT2_PO(reshape(solsBP,[N N]), L, qmf), [1, N, N, 1]);
    
   disp(['tLars = ' num2str(tLars) ', tOMP = ' num2str(tOMP)]);
    disp(['tBP = ' num2str(tBP)]);
    
    if (~mod(ii,writeFreq))
       save(fOut,'ii','LarsCSArr','OMPCSArr','BPCSArr');
    end
end

save(fOut,'ii','LarsCSArr','OMPCSArr','BPCSArr');
