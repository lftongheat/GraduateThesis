function GenFigIterChart(Mat,In,n,Epsilon)

fname = ['RhoDPlane-' Mat, '-', In, '-N', num2str(n), '.mat'];
load(fname);

deltaArr = dArr ./ n;
[Rho, Delta] = meshgrid(rhoArr, deltaArr);
K = floor(Rho.*Delta.*n);
D = floor(Delta.*n);
numTrials = size(IterVec,3);

machPrec = 1e-5;
SuccessArr = sum(ErrVecL2n <= machPrec,3);
IterArr = mean(IterVec,3) ./ D;
%[k_hat, logitCoeffs] = EstimateTransition(K,SuccessArr,size(IterVec,3),Epsilon);

figure; 
pcolor(Delta,Rho,IterArr); 
colormap (1-gray); colorbar; shading interp;
xlabel('\delta = d/n'); ylabel('\rho = k/d');

load rhoF.mat
hold on; plot(deltaF, rhoF, '--r', 'LineWidth', 2); hold off;
title('No. Iterations as a fraction of d = \delta n');
