% Generates data to test Stepwise phase transition with FDR criteria
clear all;

p = 200;
numTrials = 50;
deltaArr = linspace(0.05,1,50);
rhoArr = linspace(0.05,1,50);
zArr = linspace(0,4,16);

ErrVecL0 = zeros(length(zArr), length(deltaArr), length(rhoArr), numTrials);
ErrVecL2 = zeros(length(zArr), length(deltaArr), length(rhoArr), numTrials);
ActiveVec = zeros(length(zArr), length(deltaArr), length(rhoArr), numTrials);

for zi=16;
for di = 1:length(deltaArr);
    n = floor(p.*deltaArr(di));
    z = randn(n,1);
    zn = z*zArr(zi);
    for ki = 1:length(rhoArr)
        k = ceil(rhoArr(ki) .* n);
        disp(['z = ' num2str(zArr(zi)) ', n = ' num2str(n) ', p = '  num2str(p) ', k = ' num2str(k)]);
        for ti = 1:numTrials
            X = MakeMatrix(n,p,'USE');
            b = [100*rand(k,1); zeros(p-k,1)];
            y = X*b+zn;
            [bhat, activationHist, tHist]=SolveStepwiseFDR(X,y,0);
            ErrVecL0(zi,di,ki,ti) = length(find(abs(b - bhat) > 1e-4));
            ErrVecL2n(zi,di,ki,ti) = norm(b - bhat);
            ErrVecL2(zi,di,ki,ti) = norm(b - bhat) / norm(b);
        end
    end

    save StepwiseFDR-N200z16.mat n deltaArr rhoArr zArr di ki numTrials ErrVecL0 ErrVecL2 ErrVecL2n
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