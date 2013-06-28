% Figure08: Empirical Transition Behaviors, varying n. 
% (a) Fraction of cases with termination before stage S. 
% (b) Fraction of nonzeros missed.
% (c) Size of residual norm after S stages.

TransPars = zeros(31,3,3);
TransReslt = zeros(31,3,3);

for k=10:40,
    TransPars(k-9,:,1) = [ k   100  400 ];
    TransPars(k-9,:,2) = [ 2*k 200  800 ];
    TransPars(k-9,:,3) = [ 4*k 400 1600 ];
end
colorch = 'bgrcmyk';
symbolch = '.ox+*sdv^<>ph';

for i_indx=1:3,
  for j_indx=1:31,
        k = TransPars(j_indx,1,i_indx);
        n = TransPars(j_indx,2,i_indx);
        p = TransPars(j_indx,3,i_indx);
        Script_CFAR_Simulate
        TransReslt(j_indx,1,i_indx) = Ave_rnorm(10)/Ave_rnorm(1);
        TransReslt(j_indx,2,i_indx) = Ave_NONZ_Remain(10)/Ave_NONZ_Remain(1);
        TransReslt(j_indx,3,i_indx) = Ave_Iter_Cnt(10);
    end
end

for i_indx=1:3,
    x = TransPars(:,1,i_indx)./TransPars(:,2,i_indx);
    y = TransReslt(:,1,i_indx);
    subplot(2,1,1); plot(x,y,colorch(i_indx))
    if i_indx==1,
        title('||r_{10}||/||y||')
    end
    hold on
    xlabel('\delta')
    ylabel('\rho')
end
legend('n = 400','n=800','n=1600')
hold off

for i_indx=1:3,
    x = TransPars(:,1,i_indx)./TransPars(:,2,i_indx);
    y = TransReslt(:,2,i_indx);
    subplot(2,1,2);plot(x,y,colorch(i_indx))
    if i_indx==1,
        title('Missed Detections')
    end
    hold on
    xlabel('\delta')
    ylabel('\rho')
end
legend('n = 400','n=800','n=1600')
hold off

for i_indx=1:3,
    x = TransPars(:,1,i_indx)./TransPars(:,2,i_indx);
    y = TransReslt(:,3,i_indx);
    plot(x,y,colorch(i_indx))
    if i_indx==1,
        title('Early Terminations')
    end
    hold on
    xlabel('\delta')
    ylabel('\rho')
end
legend('n = 400','n=800','n=1600')
hold off

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
