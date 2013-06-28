% Figure14: Signal Bumps, with n = 1024 samples, and its wavelet expansion.
% Figure15: CS reconstruction of Bumps, with Homotopy, OMP, Lars, and PFP.
%
% Data dependencies:
%   DataFigBumps.mat (Created by GenDataFigBumps.m)
%

load DataFigBumps.mat

sig0 = MakeBumps(N);
L = 3;
qmf = MakeONFilter('Symmlet',8);
alpha0 = FWT_PO(sig0, L, qmf);

figure; 
subplot(2,1,1); plot(sig0); 
axis([1 N -1 5]); title(['(a) Signal Bumps, n = ' num2str(N)]);
subplot(2,1,2); PlotWaveCoeff(alpha0, L, 0);  
title('(b) Wavelet analysis');

figure; 
ii = 1;
subplot(3,4,1); plot(squeeze(xHom(ii,:))); axis([1 N -1 5]);
title(['Homotopy solution at ' num2str(iterArr(ii)) ' iters.']);
subplot(3,4,2); plot(squeeze(xLARS(ii,:))); axis([1 N -1 5]);
title(['LARS solution at ' num2str(iterArr(ii)) ' iters.']);
subplot(3,4,3); plot(squeeze(xOMP(ii,:))); axis([1 N -1 5]);
title(['OMP solution at ' num2str(iterArr(ii)) ' iters.']);
subplot(3,4,4); plot(squeeze(xPFP(ii,:))); axis([1 N -1 5]);
title(['PFP solution at ' num2str(iterArr(ii)) ' iters.']);

ii = 2;
subplot(3,4,5); plot(squeeze(xHom(ii,:))); axis([1 N -1 5]);
title(['Homotopy solution at ' num2str(iterArr(ii)) ' iters.']);
subplot(3,4,6); plot(squeeze(xLARS(ii,:))); axis([1 N -1 5]);
title(['LARS solution at ' num2str(iterArr(ii)) ' iters.']);
subplot(3,4,7); plot(squeeze(xOMP(ii,:))); axis([1 N -1 5]);
title(['OMP solution at ' num2str(iterArr(ii)) ' iters.']);
subplot(3,4,8); plot(squeeze(xPFP(ii,:))); axis([1 N -1 5]);
title(['PFP solution at ' num2str(iterArr(ii)) ' iters.']);

ii = length(iterArr);
subplot(3,4,9); plot(squeeze(xHom(ii,:))); axis([1 N -1 5]);
title(['Final Homotopy solution']);
subplot(3,4,10); plot(squeeze(xLARS(ii,:))); axis([1 N -1 5]);
title(['Final LARS solution']);
subplot(3,4,11); plot(squeeze(xOMP(ii,:))); axis([1 N -1 5]);
title(['Final OMP solution']);
subplot(3,4,12); plot(squeeze(xPFP(ii,:))); axis([1 N -1 5]);
title(['Final PFP solution']);

