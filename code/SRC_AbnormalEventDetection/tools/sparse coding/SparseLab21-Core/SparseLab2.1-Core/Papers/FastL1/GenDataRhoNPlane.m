function GenDataRhoNPlane(Alg,Mat,In,delta,nArr,rhoArr,numTrials,sigma_noise)

if (nargin < 8)
    sigma_noise = 0;
end   

IterVec = zeros(length(nArr), length(rhoArr), numTrials);
ErrVecL2n = zeros(length(nArr), length(rhoArr), numTrials);

fname = ['RhoNPlane-' Alg, '-', Mat, '-', In, '-Delta', num2str(delta*100), '.mat'];

tstart = 1;
if (exist(fname))
    load(fname);
    tstart = ti+1;
end

for ti = 1:numTrials
    for ni = 1:length(nArr)
        n = floor(nArr(ni));
        d = floor(delta.*n);
        for ki = 1:length(rhoArr)
            k = max(floor(rhoArr(ki).*d),1);
            disp(['d = ' num2str(d) ', n = ' num2str(n) ', k = ' num2str(k) ', #' num2str(ti)]);

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
                    [xhat, iters, activationHist] = SolveLasso(A, y, n, 'lars', k+5, lambda);
                case 'lasso'
                    [xhat, iters, activationHist] = SolveLasso(A, y, n, 'lasso', k+5, lambda);
                case 'omp'
                    [xhat, iters, activationHist] = SolveOMP(A, y, n, k+5, lambda);
            end
            IterVec(ni,ki,ti) = iters;
            ErrVecL2n(ni,ki,ti) = norm(x - xhat) ./ norm(x);
        end
    end
    save(fname,'delta','nArr','rhoArr','ti','numTrials','IterVec','ErrVecL2n','sigma_noise');
end

