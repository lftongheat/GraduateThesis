% Figure16: CS reconstruction of 3-D MRI data:
% Left column: X- and Y-axis projections of the original data, and one
% vertical slice; Middle column: corresponding reconstructions with
% LARS; Right column: corresponding reconstructions with OMP.
%
% Note: this figure was generated using real MRI data, which is not 
% available for distribution. However, the script GenDataFigMRI.m can 
% be used to recreate the simulation using any 3-D MRI data. 

ii = 3;
solFreq = 400;
iters = solFreq*ii;
figure;

axs = 2;
I0 = flipud(squeeze(max(abs(ImgArr(:,:,:)),[],axs)).');
subplot(3,3,1); AutoImage(I0); axis off;
title('(a) X-axis MIP of Original Data');
I_Lars = flipud(squeeze(max(abs(LarsCSArr(ii,:,:,:)),[],axs+1)).');
subplot(3,3,2); AutoImage(I_Lars); axis off;
title(['(b) X-axis MIP of LARS Output at ' num2str(iters) ' Iterations']);
I_OMP = flipud(squeeze(max(abs(OMPCSArr(ii,:,:,:)),[],axs+1)).');
subplot(3,3,3); AutoImage(I_OMP); axis off;
title(['(c) X-axis MIP of OMP Output at ' num2str(iters) ' Iterations']);

disp(['MPIX-LARS: ||I_hat-I||/||I|| = ' num2str(norm(I0-I_Lars,'fro')./norm(I0,'fro'),3)]);
disp(['MPIX-OMP: ||I_hat-I||/||I|| = ' num2str(norm(I0-I_OMP,'fro')./norm(I0,'fro'),3)]);

axs = 1;
I0 = flipud(squeeze(max(abs(ImgArr(:,:,:)),[],axs)).');
subplot(3,3,4); AutoImage(I0); axis off;
title('(d) Y-axis MIP of Original Data');
I_Lars = flipud(squeeze(max(abs(LarsCSArr(ii,:,:,:)),[],axs+1)).');
subplot(3,3,5); AutoImage(I_Lars); axis off;
title(['(e) Y-axis MIP of LARS Output at ' num2str(iters) ' Iterations']);
I_OMP = flipud(squeeze(max(abs(OMPCSArr(ii,:,:,:)),[],axs+1)).');
subplot(3,3,6); AutoImage(I_OMP); axis off;
title(['(f) Y-axis MIP of OMP Output at ' num2str(iters) ' Iterations']);

disp(['MPIY-LARS: ||I_hat-I||/||I|| = ' num2str(norm(I0-I_Lars,'fro')./norm(I0,'fro'),3)]);
disp(['MPIY-OMP: ||I_hat-I||/||I|| = ' num2str(norm(I0-I_OMP,'fro')./norm(I0,'fro'),3)]);


slice = 75;
I0 = squeeze((ImgArr(:,:,slice))).';
subplot(3,3,7); AutoImage(I0); axis off;
title('(g) Original Vertical Slice');
I_Lars = squeeze((LarsCSArr(ii,:,:,slice))).';
subplot(3,3,8); AutoImage(I_Lars); axis off;
title(['(h) LARS Output at ' num2str(iters) ' Iterations']);
I_OMP = squeeze((OMPCSArr(ii,:,:,slice))).';
subplot(3,3,9); AutoImage(I_OMP); axis off;
title(['(i) OMP Output at ' num2str(iters) ' Iterations']);

disp(['Slice-LARS: ||I_hat-I||/||I|| = ' num2str(norm(I0-I_Lars,'fro')./norm(I0,'fro'),3)]);
disp(['Slice-OMP: ||I_hat-I||/||I|| = ' num2str(norm(I0-I_OMP,'fro')./norm(I0,'fro'),3)]);

