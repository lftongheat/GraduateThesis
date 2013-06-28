clear all;

p = 200;
deltaArr = linspace(0.05,1,50);
rhoArr = linspace(0.05,1,50);
zArr = linspace(0,4,16);
numTrials=1000;

ErrVecL2 = zeros(length(zArr), length(deltaArr), length(rhoArr), numTrials);

for zi=[1 2 4 6 9 12 16]; %zi=2 => z~N(0,4)
threnter = sqrt(2*log(p));
for di = 1:length(deltaArr)
    n = floor(p.*deltaArr(di));
    z = randn(n,1);
    zn = z*zArr(zi);
    zn = z*zi; %multiply by standard deviation
    NoiseLevel = norm(zn);
    for ki = 1:length(rhoArr)
        k = ceil(rhoArr(ki) .* n);
        disp(['z = ' num2str(zi) ', n = ' num2str(n) ', p = ' num2str(p) ', k = ' num2str(k)]);

        for ti = 1:numTrials
            A = MakeMatrix(n,p,'USE');
            x = [100*rand(k,1); zeros(p-k,1)];
            y = A*x+zn;
            xhat2 = A(:,1:k) \ y; %least squares prediction
            xhat = [xhat2; zeros(p-k,1)];
            ErrVecL2(zi,di,ki,ti) = norm(x - xhat) / norm(x);
        end
    end
    save lspredictoracle1000Samplesp200.mat p deltaArr rhoArr zArr di ki numTrials ErrVecL2
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