function GenDataKDPlane(Alg,Mat,In,n,dArr,kArr,numTrials,sigma_noise)

if (nargin < 8)
    sigma_noise = 0;
end

IterVec = zeros(length(dArr), length(kArr), numTrials);
ErrVecL2n = zeros(length(dArr), length(kArr), numTrials);
SignVec = zeros(length(dArr), length(kArr), numTrials);
CorrectTermVec = zeros(length(dArr), length(kArr), numTrials);

fname = ['KDPlane-' Alg, '-', Mat, '-', In, '-N', num2str(n), '-T', num2str(numTrials), '.mat'];

tstart = 1;
if (exist(fname))
    load(fname);
    tstart = ti+1;
end

for ti = tstart:numTrials
    for di = 1:length(dArr)
        d = floor(dArr(di));
        for ki = 1:length(kArr)
            k = kArr(ki);
            disp(['d = ' num2str(d) ', n = ' num2str(n) ', k = ' num2str(k) ', t = ' num2str(ti)]);

            A = MatrixEnsemble(d,n,Mat);
            x = SparseVector(n,k,In,1);
            y = A*x;

            if (sigma_noise > 0)
                % compute the vector y, normalized
                sigma_y = std(y);
                y = y ./ sigma_y;
                x = x ./ sigma_y;

                % Add noise
                y = y + sigma_noise .* randn(d,1);
                lambda = sigma_noise .* sqrt(2*log(n));
            else
                lambda = 0;
            end

            switch lower(Alg)
                case 'lars'
                    [xhat, iters, activationHist] = SolveLasso(A, y, n, 'lars', 10*n, lambda);
                case 'lasso'
                    [xhat, iters, activationHist] = SolveLasso(A, y, n, 'lasso', 10*n, lambda);
                case 'omp'
                    [xhat, iters, activationHist] = SolveOMP(A, y, n, 10*n, lambda);
            end
            IterVec(di,ki,ti) = iters;
            ErrVecL2n(di,ki,ti) = norm(x - xhat) ./ norm(x);
            SignVec(ni,ki,ti) = length(find(activationHist < 0));
            CorrectTermVec(ni,ki,ti) = length(setdiff(activationHist,find(x ~= 0)));
        end
    end
    save(fname,'n','dArr','kArr','ti','numTrials','IterVec','ErrVecL2n','SignVec','CorrectTermVec','sigma_noise');
end

