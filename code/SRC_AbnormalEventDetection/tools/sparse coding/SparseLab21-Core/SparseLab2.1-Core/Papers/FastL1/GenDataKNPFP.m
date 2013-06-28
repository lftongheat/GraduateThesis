function GenDataKNPFP(Mat,In,d,nArr,kArr,numTrials)

IterVec = zeros(length(nArr), length(kArr), numTrials);
ErrVecL2n = zeros(length(nArr), length(kArr), numTrials);
SignVec = zeros(length(nArr), length(kArr), numTrials);
CorrectTermVec = zeros(length(nArr), length(kArr), numTrials);

fname = ['PFPKNPlane-' Mat, '-', In, '-d', num2str(d), '.mat'];

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

            [xhat1, iters1, activationHist1] = SolvePFP(A, y, n);
            IterVec(ni,ki,ti) = iters1;
            ErrVecL2n(ni,ki,ti) = norm(x - xhat1) ./ norm(x);
            SignVec(ni,ki,ti) = length(find(activationHist1 < 0));
            CorrectTermVec(ni,ki,ti) = length(setdiff(activationHist1,find(x ~= 0)));
        end
    end
    save(fname,'d','nArr','kArr','ti','numTrials','IterVec','ErrVecL2n','SignVec','CorrectTermVec');
end

