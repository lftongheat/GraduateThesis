function ComputeMaxIters(Mat,In,n,Epsilon)

machPrec = 1e-2;

fname = ['RhoDPlane-' Mat, '-', In, '-N', num2str(n), '.mat'];
load(fname);

deltaArr = dArr ./ n;
[Rho, Delta] = meshgrid(rhoArr, deltaArr);
D = floor(Delta.*n);
numTrials = size(ErrVecL2n,3);

errTol = 1e-5;
SuccessArr = sum(ErrVecL2n <= errTol,3);
SuccessArr = SuccessArr >= numTrials.*(1-Epsilon);
IterArr = median(IterVec,3) ./ D;

S = find(SuccessArr == 1);
MaxIterSuccess = max(IterArr(S));
MaxIterTotal = max(IterArr(:));
disp([Mat, ', ', In, ': Success = ' num2str(MaxIterSuccess), ', Total = ', num2str(MaxIterTotal)]);
