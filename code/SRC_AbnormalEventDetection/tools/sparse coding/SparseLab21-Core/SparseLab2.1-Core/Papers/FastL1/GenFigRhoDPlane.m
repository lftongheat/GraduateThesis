function GenFigRhoDPlane(Mat,In,n,Epsilon,Alg)

if nargin < 5
    Alg = '';
end

fname = ['RhoDPlane-' Mat, '-', In, '-N', num2str(n), '.mat'];
load(fname);

switch lower(Alg)
    case 'omp'
        IterVec = OMPIterVec;
        ErrVecL2n = OMPErrVecL2n;
    case 'lars'
        IterVec = LarsIterVec;
        ErrVecL2n = LarsErrVecL2n;
end

deltaArr = dArr ./ n;
[Rho, Delta] = meshgrid(rhoArr, deltaArr);
K = floor(Rho.*Delta.*n);
numTrials = size(IterVec,3);

machPrec = 1e-5;
thresh = repmat(K, [1, 1, numTrials]);
SuccessArr = sum((IterVec <= thresh) & (ErrVecL2n <= machPrec),3);
[k_hat, logitCoeffs] = EstimateTransition(K,SuccessArr,numTrials,Epsilon);

figure; 
pcolor(Delta,Rho,SuccessArr ./ numTrials); 
colormap (1-gray); colorbar; shading interp; 
xlabel('\delta = d/n'); ylabel('\rho = k/d');
hold on; plot(deltaArr, k_hat(:,1)'./dArr, '-r', deltaArr, k_hat(:,2)'./dArr, ... 
    ':r', deltaArr, k_hat(:,3)'./dArr, ':r', 'LineWidth', 2); hold off;
hold on; plot(deltaArr, ones(size(dArr)) ./ (2*log(n)), '--g', 'LineWidth', 2); hold off; 

rho_hat = k_hat(:,1)'./dArr;
p = polyfit((deltaArr),log(rho_hat - ones(size(dArr))./(2*log(n))),1);
rhoEst = exp(polyval(p,(deltaArr))) + ones(size(dArr))./(2*log(n));
% hold on; plot(deltaArr,rhoEst,'--g', 'LineWidth', 2); hold off;

% Diagnostics
res = rho_hat - rhoEst;
sse = sum(res.^2);
mse = sse ./ (length(deltaArr)-1);
ssto = sum((rhoEst - mean(rhoEst)).^2);
r2 = 1 - sse./ssto;

disp(['------------------------------------------------------------------']);
disp(['File name: ' fname]);
disp(['Trials = ' num2str(size(IterVec,3))]);
disp(['Transition: rho = 1/2log(n) + ' num2str(exp(p(2)),3) '*exp(' num2str(p(1),3) '*delta)']);
disp(['SSE (Residual Sum of Squares) = ' num2str(sse,5)]);
disp(['MSE (Mean Squared Error) = ' num2str(mse,5)]);
disp(['SSTO (Total sum of squares) = ' num2str(ssto,5)]);
disp(['R-squared statistic = ' num2str(r2,5)]);
disp(['------------------------------------------------------------------']);
