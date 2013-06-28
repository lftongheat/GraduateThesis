function GenDataRhoDPlaneAll(Mat,In,n,rhoArr,dArr,numTrials)

IterVec = zeros(length(dArr), length(rhoArr), numTrials);
ErrVecL2n = zeros(length(dArr), length(rhoArr), numTrials);
LarsIterVec = zeros(length(dArr), length(rhoArr), numTrials);
LarsErrVecL2n = zeros(length(dArr), length(rhoArr), numTrials);
OMPIterVec = zeros(length(dArr), length(rhoArr), numTrials);
OMPErrVecL2n = zeros(length(dArr), length(rhoArr), numTrials);

fname = ['RhoDPlane-' Mat, '-', In, '-N', num2str(n), '-T', num2str(numTrials), '.mat'];

dstart = 1;
if (exist(fname))
    load(fname);
    dstart = di+1;
end

for di = dstart:length(dArr)
    d = floor(dArr(di));
    for ki = 1:length(rhoArr)
        k = floor(rhoArr(ki) .* d);
        for ti = 1:numTrials
            disp(['d = ' num2str(d) ', n = ' num2str(n) ', k = ' num2str(k)]);

            A = MatrixEnsemble(d,n,Mat);
            x = SparseVector(n,k,In,1);
            y = A*x;

            % Solve the problem using LASSO 
            [xhat, iters, activationHist] = SolveLasso(A, y);
            IterVec(di,ki,ti) = iters;
            ErrVecL2n(di,ki,ti) = norm(x - xhat) ./ norm(x);

            % Solve the problem using LARS
            [xhat, iters, activationHist] = SolveLasso(A, y, 'lars');
            LarsIterVec(di,ki,ti) = iters;
            LarsErrVecL2n(di,ki,ti) = norm(x - xhat) ./ norm(x);

            % Solve the problem using OMP
            [xhat, iters, activationHist] = SolveOMP(A, y);
            OMPIterVec(di,ki,ti) = iters;
            OMPErrVecL2n(di,ki,ti) = norm(x - xhat) ./ norm(x);        
        end
    end
    save(fname,'n','dArr','rhoArr','di','numTrials','IterVec','ErrVecL2n','OMPIterVec','OMPErrVecL2n','LarsIterVec','LarsErrVecL2n');
end

