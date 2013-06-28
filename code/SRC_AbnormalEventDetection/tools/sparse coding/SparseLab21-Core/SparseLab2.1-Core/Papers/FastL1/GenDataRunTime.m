% GenDataRunTime: Generates the data that appears in Table 1:
% Comparison of running times on a random problem suite, for Homotopy, 
% PDCO, LP_Solve.

rand('state',4159487393);
randn('state',6504972169);

nArr = [500, 1000, 2000, 4000];
deltaArr = [0.1, 0.2, 0.4, 0.5, 0.75];
rhoArr = [0.1, 0.2, 0.4, 0.5, 0.6, 0.8];

tHom = zeros(length(nArr), length(deltaArr), length(rhoArr));
tPDCO = zeros(length(nArr), length(deltaArr), length(rhoArr));
tSimplex = zeros(length(nArr), length(deltaArr), length(rhoArr));
tPFP = zeros(length(nArr), length(deltaArr), length(rhoArr));

for ni = 1:length(nArr)
    n = nArr(ni);
    for di = 1:length(deltaArr)
        d = floor(n.*deltaArr(di));
        for ri = 1:length(rhoArr);
            k = floor(d.*rhoArr(ri));
            disp(['d = ' num2str(d) ', n = ' num2str(n) ', k = ' num2str(k)]);
            
            x = SparseVector(n,k,'Gaussian',1);
            A = MatrixEnsemble(d,n);
            y = A*x;

            % Solve using BP (via PDCO)
            tic
            xPDCO = SolveBP(A, y, n);
            tPDCO(ni,di,ri) = toc;
    
            % Solve with Simplex
            tic
            xSimplex = SolveBPSimplex(A, y);
            tSimplex(ni,di,ri) = toc;
    
            % Solve with Homotopy
            tic
            [xHom, iters, activeSet] = SolveLasso(A, y);
            tHom(ni,di,ri) = toc;

            % Solve with PFP
            tic
            [xPFP, iters, activeSet] = SolvePFP(A, y);
            tPFP(ni,di,ri) = toc;
        end
        save DataRunTime.mat nArr deltaArr rhoArr tPDCO tSimplex tHom tPFP
    end
end

