function GenFigKDPlane(Mat,In,n,Epsilon,Alg)

if nargin < 5
    Alg = '';
end

fname = [Alg 'KDPlane-' Mat, '-', In, '-N', num2str(n), '.mat'];
load(fname);

machPrec = 1e-5;
[K, D] = meshgrid(kArr, dArr);
thresh = repmat(K, [1, 1, numTrials]);
SuccessArr = sum((IterVec <= thresh) & (ErrVecL2n <= machPrec),3);
[k_hat, logitCoeffs] = EstimateTransition(K,SuccessArr,numTrials,Epsilon);

figure; 
pcolor(D,K,SuccessArr ./ numTrials); 
colormap (1-gray); colorbar; shading interp; 
xlabel('d'); ylabel('k');
hold on; plot(dArr, k_hat(:,1)', '--r', dArr, k_hat(:,2)', ...
    ':r', dArr, k_hat(:,3)', ':r', 'LineWidth', 2); hold off;
hold on; plot(dArr, dArr ./ (2*log(n)), '-g', 'LineWidth', 2); hold off; 
title(['(b) k-step termination vs. d, n = ' num2str(n)]);

figure; subplot(2,2,[1 2]); 
plot(dArr, squeeze(logitCoeffs(:,2)), '--ob', 'LineWidth', 1.5);
xlabel('d'); title(['(a) Regression coefficient \beta_1 vs. d, n = ' num2str(n)]);
axis([min(dArr) max(dArr) -1.5 0]);
kRange = linspace(min(squeeze(K(1,:))),max(squeeze(K(1,:))),200);
subplot(2,2,3); 
plot(kRange,glmval(squeeze(logitCoeffs(1,:))',kRange,'logit'),'--k', 'LineWidth', 1.5);
xlabel('d'); title(['(b) Estimated Logistic Response, n = ' num2str(n) ', d = ' num2str(dArr(1))]);
axis([min(kRange) max(kRange) 0 1]);
subplot(2,2,4); 
plot(kRange,glmval(squeeze(logitCoeffs(length(dArr),:))',kRange,'logit'),'--k', 'LineWidth', 1.5);
xlabel('d'); title(['(c) Estimated Logistic Response, n = ' num2str(n) ', d = ' num2str(dArr(length(dArr)))]);
axis([min(kRange) max(kRange) 0 1]);

% Diagnostics
res = k_hat(:,1)' - dArr ./ (2*log(n));
sse = sum(res.^2);
mse = sse ./ (length(dArr)-1);
ssto = sum((k_hat(:,1)' - mean(k_hat(:,1)')).^2);
r2 = 1 - sse./ssto;

disp(['------------------------------------------------------------------']);
disp(['File name: ' fname]);
disp(['Trials = ' num2str(size(IterVec,3))]);
disp(['Mean(res) = ' num2str(mean(res)) ', Var(res) = ' num2str(var(res))]);
disp(['SSE (Residual Sum of Squares) = ' num2str(sse,5)]);
disp(['MSE (Mean Squared Error) = ' num2str(mse,5)]);
disp(['SSTO (Total sum of squares) = ' num2str(ssto,5)]);
disp(['R-squared statistic = ' num2str(r2,5)]);
disp(['------------------------------------------------------------------']);
