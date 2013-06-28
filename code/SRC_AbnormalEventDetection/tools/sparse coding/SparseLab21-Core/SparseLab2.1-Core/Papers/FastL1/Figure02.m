% Figure02: Performance of Homotopy in decoding a rate-1/5 
% partial Hadamard code. 
% Each panel shows the number of iterations,
% divided by $n$, that Homotopy takes in order to recover
% the coded signal, versus $\eps$, the fraction of corrupt
% entries in the transmitted signal, with the noise distributed
% (a) N(0,1);  (b) $\pm 1$ with equal probabilities;
% (c) Cauchy; (d) Rayleigh.
%
% Data Dependencies: 
%   DataFig02.mat (Created by GenDataFig02.m)
%   

load DataFig02.mat

distArr = {'(a) Gaussian','(b) Bernoulli','(c) Cauchy','(d) Rayleigh'};
figure;
for di = 1:nDist
    subplot(2,2,di);
    iters = squeeze(iterArr(di,:));
    BER = squeeze(BERArr(di,:));
    
    kArr = floor(rhoArr.*delta.*len);
    plot(kArr/len,iters/len,'-r','LineWidth',1.5);
    success = find(iters == kArr);
    hold on; plot(kArr(success)/len,iters(success)/len,'or'); hold off;
    nsuccess = setdiff(1:length(kArr),success);
    hold on; plot(kArr(nsuccess)/len,iters(nsuccess)/len,'xr'); hold off;
    
    hold on; plot(kArr/len,kArr/len,'--g','LineWidth',1.5); hold off;
    axis([min(kArr/len) max(kArr/len) min(kArr/len) max(kArr/len)]); 
    xlabel('\epsilon'); ylabel('# iterations / n');
    title([distArr{di} ' noise']);
    grid on; 
end

