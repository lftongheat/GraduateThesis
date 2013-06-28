% Table01: Comparison of running times on a random problem suite, 
% for Homotopy, PDCO, LP_Solve
%
% Data Dependencies:
%   DataRunTime.mat (Created by GenDataTbl01.m)
%

load DataRunTime.mat

% Print the results in TeX format
for ni = 1:length(nArr)
    n = nArr(ni);
    for di = 1:length(deltaArr)
        d = floor(n.*deltaArr(di));
        for ri = 1:length(rhoArr);
            k = floor(d.*rhoArr(ri));
    
            fprintf('(%d,%d,%d) & %5.2f & %5.2f & %5.2f \\\\ \n', ...
            d,n,k,tHom(ni,di,ri),tSimplex(ni,di,ri),tPDCO(ni,di,ri));
            r1 = tHom(ni,di,ri)/tSimplex(ni,di,ri);
            r2 = tHom(ni,di,ri)/tPDCO(ni,di,ri);
            fprintf('rSimplex = %5.2f, rPDCO = %5.2f\n',1./r1,1./r2);
        end
    end
end


