function GenDataECC(n,R,kMin,kMax,fOut);
% GenDataECC: BER performance of Error-Correcting Codes with StOMP.

Rn = R*n;
kArr = floor(linspace(kMin,kMax,40));
numTrials = 5;

delta = R-1/R;
sigma_z = 1;
S = 10;

BER_FAR = zeros(size(kArr));
BER_FDR = zeros(size(kArr));
BER_PDCO = zeros(size(kArr));
BER_OMP = zeros(size(kArr));
t_FAR = zeros(size(kArr));
t_FDR = zeros(size(kArr));
t_PDCO = zeros(size(kArr));
t_OMP = zeros(size(kArr));

for ki = 1:length(kArr)
    k = kArr(ki);

    for ti = 1:numTrials
        disp(['ki = ' num2str(ki), ', ti = ' num2str(ti)]);
        
        % Create digital signal to be encoded
        theta = SparseVector(n,n,'Signs');

        % Create encoding matrix
        G = randn(Rn);
        [Q,R] = qr(G);
        E = Q(:,1:n);
        D = Q(:,(n+1):Rn)';

        % Encoding stage
        tx = E*theta;

        % Transmission stage: Add sparse noise
        z = SparseVector(Rn,k,'Gaussian',1) .* sigma_z;
        rx = tx+z;

        % Decoding stage: Solve with ITSP
        y = D*rx;

        a_0 = delta .* (1-k/(delta.*n)) ./ S;
        tic
        [xFAR, iters] = SolveStOMP(D, y, Rn, 'FAR', a_0, S);
        t_FAR(ki) = t_FAR(ki) + toc;
        thetaFAR = sign(E'*(rx-xFAR));
        BER_FAR(ki) = BER_FAR(ki) + sum(thetaFAR ~= theta) ./ n;

        q = min((delta.*n - k)./k,0.5);
        tic
        [xFDR, iters] = SolveStOMP(D, y, Rn, 'FDR', q, S);
        t_FDR(ki) = t_FDR(ki) + toc;
        thetaFDR = sign(E'*(rx-xFDR));
        BER_FDR(ki) = BER_FDR(ki) + sum(thetaFDR ~= theta) ./ n;

        tic
        xPDCO = SolveBP(D, y, Rn, 15, 0, 1e-2);
        t_PDCO(ki) = t_PDCO(ki) + toc;
        thetaPDCO = sign(E'*(rx-xPDCO));
        BER_PDCO(ki) = BER_PDCO(ki) + sum(thetaPDCO ~= theta) ./ n;

        tic
        xOMP = SolveOMP(D, y, Rn);
        t_OMP(ki) = t_OMP(ki) + toc;
        thetaOMP = sign(E'*(rx-xOMP));
        BER_OMP(ki) = BER_OMP(ki) + sum(thetaOMP ~= theta) ./ n;
    end
    
    t_FDR(ki) = t_FDR(ki) ./ numTrials;
    t_FAR(ki) = t_FAR(ki) ./ numTrials;
    t_PDCO(ki) = t_PDCO(ki) ./ numTrials;
    t_OMP(ki) = t_OMP(ki) ./ numTrials;
    BER_FDR(ki) = BER_FDR(ki) ./ numTrials;
    BER_FAR(ki) = BER_FAR(ki) ./ numTrials;
    BER_PDCO(ki) = BER_PDCO(ki) ./ numTrials;
    BER_OMP(ki) = BER_OMP(ki) ./ numTrials;
end

save(fOut,'n','kArr','numTrials','t_FAR','t_FDR','t_PDCO','t_OMP','BER_FDR','BER_FAR','BER_PDCO','BER_OMP');

%
% Copyright (c) 2006. David Donoho, Iddo Drori, and Yaakov Tsaig
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%