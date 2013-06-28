function GenFigSignAgreement(Mat,In,d,Epsilon,Alg)

if nargin < 5
    Alg = '';
end

fname = [Alg 'KNPlane-' Mat, '-', In, '-D', num2str(d), '.mat'];
load(fname);

machPrec = 1e-5;
[K, N] = meshgrid(kArr, nArr);
SuccessArr = sum((SignVec == 0),3);
[k_hat, logitCoeffs] = EstimateTransition(K,SuccessArr,numTrials,Epsilon);
SignArr = mean(SignVec,3);

figure;
pcolor(N,K,SuccessArr ./ numTrials); 
colormap (1-gray); colorbar; shading interp;
hold on; plot(nArr, k_hat(:,1)', '-r', nArr, k_hat(:,2)', ':r', nArr, ...
    k_hat(:,3)', ':r', 'LineWidth', 2); hold off;
%hold on; plot(nArr, d ./ (sqrt(2)*log(nArr)), '--g', 'LineWidth', 2);  hold off; 
hold on; plot(nArr, d ./ (2*log(nArr)), '--g', 'LineWidth', 2);  hold off; 
xlabel('n'); ylabel('k'); 
title('Sign Agreement');
