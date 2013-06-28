% Generate Data for Figure10: Flop count of Homotopy.

Mat = 'USE';
In = 'Uniform';

n = 1000;
numTrials = 5;
deltaArr = linspace(0.05,1,20);
rhoArr = linspace(0.05,1,40);

IterVec = zeros(length(deltaArr), length(rhoArr), numTrials);
ErrVecL2n = zeros(length(deltaArr), length(rhoArr), numTrials);
FlopsVec = zeros(length(deltaArr), length(rhoArr), numTrials);
TimeVec = zeros(length(deltaArr), length(rhoArr), numTrials);

fname = ['Flops-' Mat, '-', In, '-N', num2str(n), '-T', num2str(numTrials), '.mat'];

dstart = 1;
if (exist(fname))
    load(fname);
    dstart = di;
end

for di = dstart:length(deltaArr)
    d = floor(n.*deltaArr(di));
    for ki = 1:length(rhoArr)
        k = floor(rhoArr(ki) .* d);
        for ti = 1:numTrials
            disp(['d = ' num2str(d) ', n = ' num2str(n) ', k = ' num2str(k)]);

            A = MatrixEnsemble(d,n,Mat);
            x = SparseVector(n,k,In);
            y = A*x;

            tic
            [xhat, iters, activationHist] = SolveLasso(A, y, 'lasso');
            execTime = toc;

            IterVec(di,ki,ti) = iters;
            ErrVecL2n(di,ki,ti) = norm(x - xhat) ./ norm(x);
            TimeVec(di,ki,ti) = execTime;
            
            [xhat, iters, activationHist, flops] = SolveLasso_Flops(A, y, 'lasso');
            FlopsVec(di,ki,ti) = flops;
        end
    end
    save(fname,'n','deltaArr','rhoArr','di','numTrials','IterVec','TimeVec','ErrVecL2n','FlopsVec');
end

