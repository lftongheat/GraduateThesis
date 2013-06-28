function GenFigL0Equiv(Mat,In,n,Epsilon)

machPrec = 1e-2;

fname = ['RhoDPlane-' Mat, '-', In, '-N', num2str(n), '.mat'];
load(fname);

deltaArr = dArr ./ n;
[Rho, Delta] = meshgrid(rhoArr, deltaArr);
K = floor(Rho.*Delta.*n);
numTrials = size(ErrVecL2n,3);

machPrec = 1e-5;
SuccessArr = sum(ErrVecL2n <= machPrec,3);
[kLasso, logitCoeffs] = EstimateTransition(K,SuccessArr,size(ErrVecL2n,3),Epsilon);
LarsSuccessArr = sum(LarsErrVecL2n <= machPrec,3);
[kLars, logitCoeffs] = EstimateTransition(K,LarsSuccessArr,size(LarsErrVecL2n,3),Epsilon);
OMPSuccessArr = sum(OMPErrVecL2n <= machPrec,3);
[kOMP, logitCoeffs] = EstimateTransition(K,OMPSuccessArr,size(OMPErrVecL2n,3),Epsilon);

figure; 
plot(deltaArr, kLasso(:,1)'./dArr, '--b', deltaArr, kLars(:,1)'./dArr, '-.g', ...
     deltaArr, kOMP(:,1)'./dArr, ':r', 'LineWidth', 1.5);
 
fname = ['PFP-' Mat, '-', In, '-N', num2str(n), '.mat'];
load(fname);
deltaArr = dArr ./ n;
[Rho, Delta] = meshgrid(rhoArr, deltaArr);
K = floor(Rho.*Delta.*n);
numTrials = ti;
ErrVecL2n = ErrVecL2n(:,:,1:ti);
size(ErrVecL2n,3);
PFPSuccessArr = sum(ErrVecL2n <= machPrec,3);
[kPFP, logitCoeffs] = EstimateTransition(K,PFPSuccessArr,size(ErrVecL2n,3),Epsilon);
hold on; plot(deltaArr, kPFP(:,1)'./dArr, '-m', 'LineWidth', 1.5); hold off;

load rhoF.mat
hold on; plot(deltaF, rhoF, '--k', 'LineWidth', 2); hold off;

xlabel('\delta = d/n'); ylabel('\rho = k/d');
legend('Homotopy','LARS','OMP','PFP','\rho_W','Location','NorthWest');
