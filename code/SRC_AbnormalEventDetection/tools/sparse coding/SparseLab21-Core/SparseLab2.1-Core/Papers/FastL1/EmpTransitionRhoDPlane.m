function [deltaArr,rhoArr] = EmpTransitionRhoDPlane(Mat,In,n,Epsilon)

fname = ['RhoDPlane-' Mat, '-', In, '-N', num2str(n), '.mat'];
load(fname);

deltaArr = dArr' ./ n;
[Rho, D] = meshgrid(rhoArr, dArr);
K = floor(Rho.*D);
thresh = repmat(K, [1, 1, numTrials]);
numTrials = size(IterVec,3);
machPrec = 1e-5;
SuccessArr = sum((IterVec <= thresh) & (ErrVecL2n <= machPrec),3);
[k_hat, logitCoeffs] = EstimateTransition(K,SuccessArr,numTrials,Epsilon);
rhoArr = k_hat(:,1)./dArr';

if (deltaArr(length(deltaArr)) == 1)
    rhoArr(length(rhoArr)) = 1;
else
    deltaArr = [deltaArr; 1];
    rhoArr = [rhoArr; 1];
end
