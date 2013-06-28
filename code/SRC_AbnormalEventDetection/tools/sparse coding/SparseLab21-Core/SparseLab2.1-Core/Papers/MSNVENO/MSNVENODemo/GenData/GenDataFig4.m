% Generates data to test Stepwise phase transition with noise
clear all;

n = 200;
numTrials = 50;
deltaArr = linspace(0.05,1,50);
rhoArr = linspace(0.05,1,50);
zArr = linspace(0,4,16);

ErrVecL0 = zeros(length(zArr), length(deltaArr), length(rhoArr), numTrials);
ErrVecL2 = zeros(length(zArr), length(deltaArr), length(rhoArr), numTrials);
ActiveVec = zeros(length(zArr), length(deltaArr), length(rhoArr), numTrials);


%for zi = 1:length(zArr)
for zi=16;
for di = 1:length(deltaArr)
    d = floor(n.*deltaArr(di));
    z = randn(d,1);
    zn = z*zArr(zi);
    NoiseLevel = norm(zn);
    for ki = 1:length(rhoArr)
        k = ceil(rhoArr(ki) .* d);
        disp(['z = ' num2str(zArr(zi)) ', d = ' num2str(d) ', n = '  num2str(n) ', k = ' num2str(k)]);

        for ti = 1:numTrials
            A = MakeMatrix(d,n,'USE');
            x = [100*rand(k,1); zeros(n-k,1)];
            y = A*x+zn;
            [xhat, activationHist, tHist] =SolveStepwise(A,y,4,0,NoiseLevel);
            ErrVecL0(zi,di,ki,ti) = length(find(abs(x - xhat) > 1e-4));
            ErrVecL2n(zi,di,ki,ti) = norm(x - xhat);
            ErrVecL2(zi,di,ki,ti) = norm(x - xhat) / norm(x);
        end
        
    end

    save StepwisePhaseData-N200z16.mat n deltaArr rhoArr zArr di ki numTrials ErrVecL0 ErrVecL2 ErrVecL2n
end
end

%
% Copyright (c) 2006. Victoria Stodden
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
