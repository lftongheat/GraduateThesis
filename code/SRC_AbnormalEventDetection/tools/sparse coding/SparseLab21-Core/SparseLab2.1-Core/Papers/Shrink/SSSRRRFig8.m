% This script generates the three figures that compose Figure 8. Please
% note that since this experiment is using a random dictionary, the figures
% may show slight deviation from the paper's figure. 

%clear all;
%close all;
ITERALL=10;
SigDim=100;
sigma=0.03*1.2.^(0:1:19);
SigNUM=20;

% Construction of Tight frame & normalized columns
D=[];
for k=1:1:10, 
    D=[D,orth(randn(SigDim,SigDim))];
end;
T=pinv(D);
alpha=1/max(max(T'*T));

% The Main Loops
Res0=zeros(20*20*100,5);
count=1;
for NONZEROS=1:1:20,
    for NOISEP=1:1:20,
        disp([NONZEROS,NOISEP]);
        
        thr=1:1:100;
        thr=thr*sigma(NOISEP)^2;
        for signal=1:1:SigNUM,
            Res0(count,1)=NONZEROS;
            Res0(count,2)=NOISEP;
            
            a0=zeros(10*SigDim,1);
            Pos=randperm(10*SigDim);
            a0(Pos(1:NONZEROS))=randn(NONZEROS,1);
            x0=D*a0;
            x0=x0/norm(x0);
            y=x0+randn(SigDim,1)*sigma(NOISEP);
            
            % Algorithm D for denoising - parallel CD - fixed mu
            Fast=2;
            if Fast==1, % fixed thr
                thr=5*sigma(NOISEP)^2;
                a=zeros(10*SigDim,1);
                for Iter=1:1:ITERALL,
                    aT=D'*(y-D*a)+a;
                    aT=(aT-sign(aT)*thr).*(abs(aT)>=thr);
                    mu=1/alpha;
                    a=a+mu*(aT-a);
                    Res0(count,Iter+3)=((D*a-x0)'*(D*a-x0))/((y-x0)'*(y-x0));
                end;
            else, % seek the best thr
                ResTEMP=zeros(100,ITERALL);
                for k=1:1:100,
                    a=zeros(10*SigDim,1);
                    for Iter=1:1:ITERALL,
                        aT=D'*(y-D*a)+a;
                        aT=(aT-sign(aT)*thr(k)).*(abs(aT)>=thr(k));
                        % aT=aT.*(abs(aT)>=thr(k)); % corresponds to L0
                        mu=1/alpha;
                        a=a+mu*(aT-a);
                        ResTEMP(k,Iter)=((D*a-x0)'*(D*a-x0))/((y-x0)'*(y-x0));
                    end;
                end;
                % pos=find(mean(ResTEMP,2)==min(mean(ResTEMP,2)));
                % Res0(count,3)=pos(1);
                % Res0(count,4:3+ITERALL)=ResTEMP(pos(1),:);
                Res0(count,4:3+ITERALL)=min(ResTEMP);
            end;
            % disp(Res0(count,:));
            pause(0.0001);
            count=count+1;
        end;
    end; 
end;

save EXPERIMENT5

MAP1=zeros(20,20);
MAP2=zeros(20,20);
MAP3=zeros(20,20);
for NONZEROS=1:1:20,
    for NOISEP=1:1:20,
        pos=find(Res0(:,1)==NONZEROS & Res0(:,2)==NOISEP);
        MAP1(NONZEROS,NOISEP)=mean(Res0(pos,4));
        MAP2(NONZEROS,NOISEP)=mean(Res0(pos,8));        
        MAP3(NONZEROS,NOISEP)=mean(Res0(pos,13));        
    end;
end;
figure(1); clf;
SNR=20*log10(1./(0.03*1.2.^(0:1:19)));
imagesc(SNR,1:1:20,MAP1); 
set(gca,'FontSize',16);
xlabel('Signal-to-Noise Ratio [dB]');
ylabel('Cardinality L');
title('Noise decay factor - 1 iteration');
colormap(gray(256)); colorbar; axis square;
set(gca,'FontSize',16);
hold on; 
contour(SNR,1:1:20,MAP1,20,'r');

figure(2); clf; 
imagesc(SNR,1:1:20,MAP3); 
set(gca,'FontSize',16);
xlabel('Signal-to-Noise Ratio [dB]');
title('Noise decay factor - 10 iterations');
colormap(gray(256)); colorbar; axis square;
set(gca,'FontSize',16);
hold on; 
contour(SNR,1:1:20,MAP3,20,'r');

figure(3); clf; 
imagesc(SNR,1:1:20,10*log10(MAP1./MAP3)); 
set(gca,'FontSize',16);
xlabel('Signal-to-Noise Ratio [dB]');
title('Improvement in SNR [dB]');
colormap(gray(256)); colorbar; axis square;
set(gca,'FontSize',16);
hold on; 
contour(SNR,1:1:20,10*log10(MAP1./MAP3),10,'r');
