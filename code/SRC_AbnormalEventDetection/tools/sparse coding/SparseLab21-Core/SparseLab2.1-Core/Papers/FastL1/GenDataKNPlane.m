function GenDataKNPlane(Alg,Mat,In,d,nArr,kArr,numTrials,sigma_noise)

if (nargin < 8)
    sigma_noise = 0;
end

IterVec = zeros(length(nArr), length(kArr), numTrials);
ErrVecL2n = zeros(length(nArr), length(kArr), numTrials);
SignVec = zeros(length(nArr), length(kArr), numTrials);
CorrectTermVec = zeros(length(nArr), length(kArr), numTrials);

fname = ['KNPlane-' Alg, '-', Mat, '-', In, '-D', num2str(d), '-T', num2str(numTrials), '.mat'];

tstart = 1;
if (exist(fname))
    load(fname);
    tstart = ti+1;
end

for ti = tstart:numTrials
    for ni = 1:length(nArr)
        n = floor(nArr(ni));
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
            IterVec(ni,ki,ti) = iters;
            ErrVecL2n(ni,ki,ti) = norm(x - xhat) ./ norm(x);
            SignVec(ni,ki,ti) = length(find(activationHist < 0));
            CorrectTermVec(ni,ki,ti) = length(setdiff(activationHist,find(x ~= 0)));
        end
    end
    save(fname,'d','nArr','kArr','ti','numTrials','IterVec','ErrVecL2n','SignVec','CorrectTermVec','sigma_noise');
end

