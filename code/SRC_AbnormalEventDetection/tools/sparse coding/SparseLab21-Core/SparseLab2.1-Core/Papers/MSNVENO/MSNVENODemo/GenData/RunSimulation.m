function ErrVecL2n = RunSimulation(n,p,zi,method);

numTrials = 1000;

%deltaArr = linspace(0.05,1,50);
rhoArr = linspace(0.05,1,50);

ErrVecL2n = zeros(length(rhoArr), numTrials);
ActiveVec = zeros(length(rhoArr), numTrials);

threnter = sqrt(2*log(p));

%    n = floor(p.*deltaArr(di));

    z = randn(n,1);
    zn = z*zi; %multiply by standard deviation
    NoiseLevel = norm(zn);

    for ki = 1:length(rhoArr)
        k = ceil(rhoArr(ki) .* n);
        disp(['method = ' method ', z = ' num2str(zi) ', n = ' num2str(n) ', p = '  num2str(p) ', k = ' num2str(k)]);

        for ti = 1:numTrials
            A = MakeMatrix(n,p,'USE');
            x = [100*rand(k,1); zeros(p-k,1)];
            y = A*x+zn;

            if strcmp(method,'Stepwise2logp'),
              [xhat, activationHist, tHist] =SolveStepwise(A,y,threnter,0);
              ErrVecL2n(ki,ti) = norm(x - xhat) / norm(x);

            elseif strcmp(method,'StepwiseFDR'),
              [xhat, activationHist, tHist] =SolveStepwiseFDR(A,y,threnter,0);
              ErrVecL2n(ki,ti) = norm(x - xhat) / norm(x);

            elseif strcmp(method,'LARS'),
              [xhat, activationHist, tHist] = FastLars(A,y,threnter,0);
              ErrVecL2n(ki,ti) = norm(x - xhat) / norm(x);

            elseif strcmp(method,'LASSO'),
              [xhat, activationHist, tHist] = FastLars(A,y,threnter,0);
              ErrVecL2n(ki,ti) = norm(x - xhat) / norm(x);
            end
        end
    eval(['save ',['Stepwise2logppMoreSamples' int2str(p) 'zi' int2str(zi)]]);
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
