function GenFigKNPlane(Mat,In,d,Epsilon,Alg)

if nargin < 5
    Alg = '';
end

fname = [Alg 'KNPlane-' Mat, '-', In, '-D', num2str(d), '.mat'];
load(fname);

machPrec = 1e-5;
[K, N] = meshgrid(kArr, nArr);
thresh = repmat(K, [1, 1, numTrials]);
SuccessArr = sum((IterVec <= thresh) & (ErrVecL2n <= machPrec),3);
[k_hat, logitCoeffs] = EstimateTransition(K,SuccessArr,numTrials,Epsilon);

figure; 
pcolor(N,K,SuccessArr ./ numTrials); 
colormap (1-gray); colorbar; shading interp; 
hold on; plot(nArr, k_hat(:,1)', '-r', nArr, k_hat(:,2)', ':r', nArr, ...
    k_hat(:,3)', ':r', 'LineWidth', 2); hold off;
hold on; plot(nArr, d ./ (2*log(nArr)), '--g', 'LineWidth', 2);  hold off; 
xlabel('n'); ylabel('k'); title(['(a) k-step termination vs. n, d = ' num2str(d)]);

figure; subplot(2,2,[1 2]); 
plot(nArr, squeeze(logitCoeffs(:,2)), '--b', 'LineWidth', 1.5);
hold on; plot(nArr, squeeze(logitCoeffs(:,2)), 'xb', 'MarkerSize', 6); hold off;
xlabel('n'); title(['(a) Regression coefficient \beta_1 vs. n, d = ' num2str(d)]);
grid on; axis([min(nArr) max(nArr) -1.5 0]);
kRange = linspace(min(squeeze(K(1,:))),max(squeeze(K(1,:))),200);
subplot(2,2,3); 
plot(kRange,glmval(squeeze(logitCoeffs(1,:))',kRange,'logit'),'-b', 'LineWidth', 1.5);
xlabel('k'); title(['(b) Estimated Logistic Response, n = ' num2str(nArr(1)) ', d = ' num2str(d)]);
axis([min(kRange) max(kRange) 0 1]);
subplot(2,2,4); 
plot(kRange,glmval(squeeze(logitCoeffs(length(nArr),:))',kRange,'logit'),'-b', 'LineWidth', 1.5);
xlabel('k'); title(['(c) Estimated Logistic Response, n = ' num2str(nArr(length(nArr))) ', d = ' num2str(d)]);
axis([min(kRange) max(kRange) 0 1]);

% Diagnostics
res = k_hat(:,1)' - d ./ (2*log(nArr));
sse = sum(res.^2);
mse = sse ./ (length(nArr)-1);
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
