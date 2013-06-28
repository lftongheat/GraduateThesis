function GenFigRhoNPlane(Mat,In,delta,Epsilon,Alg)

if nargin < 5
    Alg = '';
end

fname = ['RhoNPlane-', Mat, '-', In, '-Delta', num2str(delta*100), '.mat'];
load(fname);
numTrials = size(IterVec,3);

dArr = floor(delta .* nArr);
[Rho, N] = meshgrid(rhoArr, nArr);
K = floor(Rho .* floor(delta.*N));
machPrec = 1e-5;
thresh = repmat(K, [1, 1, numTrials]);
SuccessArr = sum((IterVec <= thresh) & (ErrVecL2n <= machPrec),3);
[k_hat, logitCoeffs] = EstimateTransition(K,SuccessArr,numTrials,Epsilon);

figure; 
pcolor(N,Rho,SuccessArr ./ numTrials); 
colormap (1-gray); colorbar; shading interp; 
hold on; plot(nArr, k_hat(:,1)'./dArr, '-r', nArr, k_hat(:,2)'./dArr, ':r', nArr, ...
    k_hat(:,3)'./dArr, ':r', 'LineWidth', 2); hold off;
%hold on; plot(nArr, 1 ./ (2*log(nArr)), '--g', 'LineWidth', 2);  hold off; 
xlabel('n'); ylabel('\rho = k/d'); 

