%========================================================
% Experiment 1 - Tight frame with normalized columns
%========================================================

clear all;
close all;
ITERALL=5;
NONZEROS=15;
NOISEP=0.3;
SigDim=100;
thr=1e-3:1e-2:1;

% Construction of the data - Tight frame & normalized columns
D=[];
for k=1:1:10, 
    D=[D,orth(randn(SigDim,SigDim))];
end;
a0=zeros(10*SigDim,1);
Pos=randperm(10*SigDim);
a0(Pos(1:NONZEROS))=randn(NONZEROS,1);
x0=D*a0;
y=x0+randn(SigDim,1)*NOISEP;
T=pinv(D);
alpha=1/max(max(T'*T));

% Algorithm A for denoising - heuristic shrinkage  threshold=lambda/alpha
proj=T*y; 
for k=1:1:length(thr),
    projT=(proj-sign(proj)*thr(k)/alpha).*(abs(proj)>=thr(k)/alpha);
    xest=D*projT; % like applying pinv(T)
    Res1(k)=((xest-x0)'*(xest-x0))/((y-x0)'*(y-x0));
end;
figure(1); clf;
plot(thr,Res1,'b');
hold on;

% Algorithm B for denoising - IRLS
disp('Denoising by IRLS');
Res2=zeros(length(thr),ITERALL);
for k=1:1:length(thr),
    a=ones(1000,1);
    for Iter=1:1:ITERALL,
        W=diag(2./(abs(a)+1e-8));
        a=inv(thr(k)*W+D'*D)*D'*y;
        xest=D*a; 
        Res2(k,Iter)=((xest-x0)'*(xest-x0))/((y-x0)'*(y-x0));
    end;
    disp([k,Res2(k,:)]);
    pause(0.0001);
end;
figure(1); clf;
plot(thr,Res1,'b');
set(gca,'FontSize',14)
hold on;
plot(thr,Res2(:,1),':');
plot(thr,Res2(:,5),'--');
axis([0 1 0.3 1.3]);
grid on;
h=legend({'Simple Shrinkage','IRLS - 1st iteration','IRLS - 5th iteration'},2);
set(h,'FontSize',14);
h=xlabel('\lambda');
set(h,'FontSize',14);
h=ylabel('Noise decay factor');
set(h,'FontSize',14);
h=title('IRLS versus simple shrinkage');
set(h,'FontSize',14);
print -depsc2 Case1_IRLS_vs_Shrinkage.eps

% Algorithm C for denoising - sequential CD
disp('Denoising by sequencially updating the coefficients');
Res3=zeros(length(thr),ITERALL);
for k=1:1:length(thr),
    a=zeros(1000,1);
    for Iter=1:1:ITERALL,
        for kk=1:1:10*SigDim,
            a1=D(:,kk)'*(y-D*a+D(:,kk)*a(kk));
            a(kk)=(a1-sign(a1)*thr(k)).*(abs(a1)>=thr(k));
        end;
        xest=D*a; 
        Res3(k,Iter)=((xest-x0)'*(xest-x0))/((y-x0)'*(y-x0));
    end;
    disp([k,Res3(k,:)]);
    pause(0.0001);
end;
figure(2); clf;
plot(thr,Res1,'b');
set(gca,'FontSize',14)
hold on;
plot(thr,Res3(:,1),':');
plot(thr,Res3(:,5),'--');
axis([0 1 0.3 1.3]);
grid on;
h=legend({'Simple Shrinkage','Sequential Shrinkage - 1st iteration',...
    'Sequential Shrinkage - 5th iteration'},2);
set(h,'FontSize',14);
h=xlabel('\lambda');
set(h,'FontSize',14);
h=ylabel('Noise decay factor');
set(h,'FontSize',14);
h=title('Sequential Shrinkage versus simple shrinkage');
set(h,'FontSize',14);
print -depsc2 Case1_SeqShrink_vs_Shrinkage.eps

% Algorithm D for denoising - parallel CD - fixed mu
disp('Denoising by updating the coefficients in parallel');
Res4=zeros(length(thr),ITERALL);
for k=1:1:length(thr),
    a=zeros(10*SigDim,1);
    for Iter=1:1:ITERALL,
        aT=D'*(y-D*a)+a; 
        aT=(aT-sign(aT)*thr(k)).*(abs(aT)>=thr(k));
        mu=1/alpha; 
        a=a+mu*(aT-a);
        Res4(k,Iter)=((D*a-x0)'*(D*a-x0))/((y-x0)'*(y-x0));
    end;
    disp([k,Res4(k,:)]);
    pause(0.0001);
end;
figure(3); clf;
plot(thr,Res1,'b');
set(gca,'FontSize',14);
hold on;
plot(thr,Res4(:,1),'.');
plot(thr,Res4(:,5),'--');
axis([0 1 0.3 1.3]);
grid on; 
h=legend({'Simple Shrinkage','parallel Shrinkage - 1st iteration',...
    'Parallel Shrinkage - 5th iteration'},2);
set(h,'FontSize',14);
h=xlabel('\lambda');
set(h,'FontSize',14);
h=ylabel('Noise decay factor');
set(h,'FontSize',14);
h=title('Parallel Shrinkage (Fixed \mu=1/\alpha) versus simple shrinkage');
print -depsc2 Case1_ParShrink1_vs_Shrinkage.eps

% Algorithm D for denoising - parallel CD - line-search
disp('Denoising by updating the coefficients in parallel');
Res5=zeros(length(thr),ITERALL);
Mu_all=zeros(length(thr),1);
for k=1:1:length(thr),
    a=zeros(10*SigDim,1);
    for Iter=1:1:ITERALL,
        Da=D*a;
        aT=D'*(y-Da)+a; 
        aT=(aT-sign(aT)*thr(k)).*(abs(aT)>=thr(k));
        % Line-search - brute-force
        delta=aT-a;
        funcVal=zeros(1000,1);
        Ddelta=D*delta;
        for mu=0.001:0.001:1,
            funcVal(round(mu*1000)) =thr(k)*sum(abs(a+mu*delta))+...
                     0.5*(Da-y+Ddelta*mu)'*(Da-y+Ddelta*mu);
        end;
        pos=find(funcVal==min(funcVal));
        mu0=pos(1)/1000;
        if Iter==1, 
            Mu_all(k)=mu0;
        end;
        % end of line-search
        a=a+mu0*delta;
        Res5(k,Iter)=((D*a-x0)'*(D*a-x0))/((y-x0)'*(y-x0));
    end;
    disp([k,Res5(k,:)]);
    pause(0.0001);
end;
figure(4); clf;
plot(thr,Res1,'b');
set(gca,'FontSize',14);
hold on;
plot(thr,Res5(:,1),'.');
plot(thr,Res5(:,5),'--');
axis([0 1 0.3 1.3]); grid on;
h=legend({'Simple Shrinkage','Parallel Shrinkage - 1st iteration',...
    'Parallel Shrinkage - 5th iteration'},2);
set(h,'FontSize',14);
h=xlabel('\lambda');
set(h,'FontSize',14);
h=ylabel('Noise decay factor');
set(h,'FontSize',14);
h=title('Parallel Shrinkage (+Line-Search) versus simple shrinkage');
set(h,'FontSize',14);
print -depsc2 Case1_ParShrink2_vs_Shrinkage.eps

figure(5); clf;
plot(thr,Mu_all);
set(gca,'FontSize',14);
h=xlabel('\lambda');
set(h,'FontSize',14);
h=ylabel('Optimal first iteration \mu');
set(h,'FontSize',14);
grid on;
print -depsc2 Case1_Opt_Mu.eps

save EXPERIMENT1 Res1 Res2 Res3 Res4 Res5 Mu_all thr D T y a0 x0 ITERALL NONZEROS NOISEP SigDim

%========================================================
% Experiment 2 - As above - showing the objective function decay
%========================================================

thr0=0.3;
Fnc=zeros(4,50);
Fnc(:,1)=0.5*(D*ones(1000,1)-y)'*(D*ones(1000,1)-y)+thr0*sum(abs(a));

% Algorithm B for denoising - IRLS
a=ones(1000,1);
for Iter=1:1:50,
    W=diag(2./(abs(a)+1e-10));
    a=inv(thr0*W+D'*D)*D'*y;
    xest=D*a;
    Fnc(1,Iter+1)=0.5*(xest-y)'*(xest-y)+thr0*sum(abs(a));
    disp([Iter,Fnc(1,Iter+1)]);
    pause(0.0001);
end;

% Algorithm C for denoising - sequential CD
a=ones(1000,1);
for Iter=1:1:50,
    for kk=1:1:10*SigDim,
        a1=D(:,kk)'*(y-D*a+D(:,kk)*a(kk));
        a(kk)=(a1-sign(a1)*thr0).*(abs(a1)>=thr0);
    end;
    xest=D*a;
    Fnc(2,Iter+1)=0.5*(xest-y)'*(xest-y)+thr0*sum(abs(a));
    disp([Iter,Fnc(2,Iter+1)]);
    pause(0.0001);
end;

% Algorithm D for denoising - parallel CD - fixed mu
a=ones(10*SigDim,1);
for Iter=1:1:50,
    aT=D'*(y-D*a)+a;
    aT=(aT-sign(aT)*thr0).*(abs(aT)>=thr0);
    mu=2/alpha;
    a=a+mu*(aT-a);
    xest=D*a;
    Fnc(3,Iter+1)=0.5*(xest-y)'*(xest-y)+thr0*sum(abs(a));
    disp([Iter,Fnc(3,Iter+1)]);
    pause(0.0001);
end;

% Algorithm D for denoising - parallel CD - line-search
a=ones(10*SigDim,1);
for Iter=1:1:50,
    Da=D*a;
    aT=D'*(y-Da)+a;
    aT=(aT-sign(aT)*thr0).*(abs(aT)>=thr0);
    delta=aT-a;
    funcVal=zeros(1000,1);
    Ddelta=D*delta;
    for mu=0.001:0.001:1,
        funcVal(round(mu*1000)) =thr0*sum(abs(a+mu*delta))+...
            0.5*(Da-y+Ddelta*mu)'*(Da-y+Ddelta*mu);
    end;
    pos=find(funcVal==min(funcVal));
    mu0=pos(1)/1000;
    a=a+mu0*delta;
    xest=D*a;
    Fnc(4,Iter+1)=0.5*(xest-y)'*(xest-y)+thr0*sum(abs(a));
    disp([Iter,Fnc(4,Iter+1)]);
    pause(0.0001);
end;

figure(6); clf;
semilogy(Fnc(1,:),'b-.');
set(gca,'FontSize',14);
hold on;
h=xlabel('Iteration');
set(h,'FontSize',14);
h=ylabel('Objective function value');
set(h,'FontSize',14);
semilogy(Fnc(2,:),'b');
semilogy(Fnc(3,:),'b--');
semilogy(Fnc(4,:),'b:');
axis([0 50 0 500]);
grid on;
h=legend({'IRLS','Sequential Shrinkage',...
    'Parallel Shrinkage - fixed \mu','Parallel Shrinkage with line-search'});
set(h,'FontSize',14);
print -depsc2 Case1_Objective_Minimization.eps

save EXPERIMENT2 Fnc thr0 D T y a0 x0 NOISEP SigDim

%========================================================
% Experiment 3 - Arbitrary frame with normalized columns
%========================================================

clear all;
close all;
ITERALL=5;
NONZEROS=15;
NOISEP=0.3;
SigDim=100;
thr=2.5e-3:4e-3:1;

% Construction of the data - general frame with normalized columns
D=randn(SigDim,10*SigDim);
for k=1:1:10*SigDim,
    D(:,k)=D(:,k)/norm(D(:,k));
end;
a0=zeros(10*SigDim,1);
Pos=randperm(10*SigDim);
a0(Pos(1:NONZEROS))=randn(NONZEROS,1);
x0=D*a0;
y=x0+randn(SigDim,1)*NOISEP;
T=pinv(D);

% Algorithm A for denoising - heuristic shrinkage  threshold=lambda/alpha
proj=T*y; 
for k=1:1:length(thr),
    projT=(proj-sign(proj)*thr(k)).*(abs(proj)>=thr(k));
    xest=D*projT; % like applying pinv(T)
    Res1(k)=((xest-x0)'*(xest-x0))/((y-x0)'*(y-x0));
end;figure(1); clf;
plot(thr,Res1,'b');
hold on;

% Algorithm B for denoising - IRLS
disp('Denoising by IRLS');
DD=D'*D;
Res2=zeros(length(thr),ITERALL);
for k=1:1:length(thr),
    a=ones(1000,1);
    for Iter=1:1:ITERALL,
        W=diag(2./(abs(a)+1e-8));
        a=inv(thr(k)*W+DD)*D'*y;
        xest=D*a; 
        Res2(k,Iter)=((xest-x0)'*(xest-x0))/((y-x0)'*(y-x0));
    end;
    disp([k,Res2(k,:)]);
    pause(0.0001);
end;
figure(1); clf;
plot(thr,Res1,'b');
set(gca,'FontSize',14);
hold on;
plot(thr,Res2(:,1),':');
plot(thr,Res2(:,5),'--');
axis([0 1 0 2.5]);
h=legend({'Simple Shrinkage','IRLS - 1st iteration','IRLS - 5th iteration'},1);
set(h,'FontSize',14);
h=xlabel('\lambda');
set(h,'FontSize',14);
h=ylabel('Noise decay factor');
set(h,'FontSize',14);
h=title('IRLS versus simple shrinkage');
set(h,'FontSize',14);
grid on;
print -depsc2 Case2_IRLS_vs_Shrinkage.eps

% Algorithm C for denoising - sequential CD
disp('Denoising by sequencially updating the coefficients');
Res3=zeros(length(thr),ITERALL);
for k=1:1:length(thr),
    a=zeros(1000,1);
    for Iter=1:1:ITERALL,
        for kk=1:1:10*SigDim,
            a1=D(:,kk)'*(y-D*a+D(:,kk)*a(kk));
            a(kk)=(a1-sign(a1)*thr(k)).*(abs(a1)>=thr(k));
        end;
        xest=D*a; 
        Res3(k,Iter)=((xest-x0)'*(xest-x0))/((y-x0)'*(y-x0));
    end;
    disp([k,Res3(k,:)]);
    pause(0.0001);
end;
figure(2); clf;
plot(thr,Res1,'b');
set(gca,'FontSize',14);
hold on;
plot(thr,Res3(:,1),':');
plot(thr,Res3(:,5),'--');
axis([0 1 0 2.5]);
h=legend({'Simple Shrinkage','Sequential Shrinkage - 1st iteration',...
    'Sequential Shrinkage - 5th iteration'},1);
set(h,'FontSize',14);
h=xlabel('\lambda');
set(h,'FontSize',14);
h=ylabel('Noise decay factor');
set(h,'FontSize',14);
h=title('Sequential Shrinkage versus simple shrinkage');
set(h,'FontSize',14);
grid on;
print -depsc2 Case2_SeqShrink_vs_Shrinkage.eps

% Algorithm D for denoising - parallel CD - line-search
disp('Denoising by updating the coefficients in parallel');
Res5=zeros(length(thr),ITERALL);
for k=1:1:length(thr),
    a=zeros(10*SigDim,1);
    for Iter=1:1:ITERALL,
        Da=D*a;
        aT=D'*(y-Da)+a; 
        aT=(aT-sign(aT)*thr(k)).*(abs(aT)>=thr(k));
        % Line-search - brute-force
        delta=aT-a;
        funcVal=zeros(1000,1);
        Ddelta=D*delta;
        for mu=0.001:0.001:1,
            funcVal(round(mu*1000)) =thr(k)*sum(abs(a+mu*delta))+...
                     0.5*(Da-y+Ddelta*mu)'*(Da-y+Ddelta*mu);
        end;
        pos=find(funcVal==min(funcVal));
        mu0=pos(1)/1000;
        % end of line-search
        a=a+mu0*delta;
        Res5(k,Iter)=((D*a-x0)'*(D*a-x0))/((y-x0)'*(y-x0));
    end;
    disp([k,Res5(k,:)]);
    pause(0.0001);
end;
figure(4); clf;
plot(thr,Res1,'b');
set(gca,'FontSize',14);
hold on;
plot(thr(1:3:end),Res5(1:3:end,1),'.');
plot(thr,Res5(:,5),'--');
axis([0 1 0 2.5]);
h=legend({'Simple Shrinkage','Parallel Shrinkage - 1st iteration',...
    'Parallel Shrinkage - 5th iteration'},1);
set(h,'FontSize',14);
h=xlabel('\lambda');
set(h,'FontSize',14);
h=ylabel('Noise decay factor');
set(h,'FontSize',14);
h=title('Parallel Shrinkage (+Line-Search) versus simple shrinkage');
set(h,'FontSize',14);
grid on;
print -depsc2 Case2_ParShrink2_vs_Shrinkage.eps

save EXPERIMENT3 Res1 Res2 Res3 Res5  thr D T y a0 x0 ITERALL NONZEROS NOISEP SigDim

%========================================================
% Experiment 4 - Arbitrary frame 
%========================================================

clear all;
close all;
ITERALL=5;
NONZEROS=15;
NOISEP=0.3;
SigDim=100;
thr=1e-3:1e-2:1;

% Construction of the data - general frame with normalized columns
D=0.1*randn(SigDim,10*SigDim);
for k=1:1:10*SigDim,
    D(:,k)=D(:,k)/norm(D(:,k))*(k/(10*SigDim)+0.5)/1.5;
end;
a0=zeros(10*SigDim,1);
Pos=randperm(10*SigDim);
a0(Pos(1:NONZEROS))=randn(NONZEROS,1);
x0=D*a0;
y=x0+randn(SigDim,1)*NOISEP;
T=pinv(D);
w=1./diag(D'*D);

% Algorithm A for denoising - heuristic shrinkage  threshold=lambda/alpha
proj=T*y; 
for k=1:1:length(thr),
    projT=(proj-sign(proj)*thr(k)).*(abs(proj)>=thr(k));
    xest=D*projT; % like applying pinv(T)
    Res1(k)=((xest-x0)'*(xest-x0))/((y-x0)'*(y-x0));
end;
figure(1); clf;
plot(thr,Res1,'b');
hold on;

% Algorithm D for denoising - parallel CD - line-search
disp('Denoising by updating the coefficients in parallel');
Res5=zeros(length(thr),ITERALL);
for k=1:1:length(thr),
    a=zeros(10*SigDim,1);
    for Iter=1:1:ITERALL,
        Da=D*a;
        aT=w.*(D'*(y-Da)+a); 
        aT=(aT-sign(aT).*w.*thr(k)).*(abs(aT)>=thr(k)*w);
        % Line-search - brute-force
        delta=aT-a;
        funcVal=zeros(1000,1);
        Ddelta=D*delta;
        for mu=0.001:0.001:1,
            funcVal(round(mu*1000)) =thr(k)*sum(abs(a+mu*delta))+...
                     0.5*(Da-y+Ddelta*mu)'*(Da-y+Ddelta*mu);
        end;
        pos=find(funcVal==min(funcVal));
        mu0=pos(1)/1000;
        % end of line-search
        a=a+mu0*delta;
        Res5(k,Iter)=((D*a-x0)'*(D*a-x0))/((y-x0)'*(y-x0));
    end;
    disp([k,Res5(k,:)]);
    pause(0.0001);
end;
figure(4); clf;
plot(thr,Res1,'b');
set(gca,'FontSize',14);
hold on;
plot(thr,Res5(:,1),'.');
plot(thr,Res5(:,5),'--');
axis([0 1 0.5 1.5]);
h=legend({'Simple Shrinkage','Parallel Shrinkage - 1st iteration',...
    'Parallel Shrinkage - 5th iteration'},1);
set(h,'FontSize',14);
h=xlabel('\lambda');
set(h,'FontSize',14);
h=ylabel('Noise decay factor');
set(h,'FontSize',14);
h=title('Parallel Shrinkage (+Line-Search) versus simple shrinkage');
set(h,'FontSize',14);
grid on;
print -depsc2 Case3_ParShrink2_vs_Shrinkage.eps

save EXPERIMENT4 Res1 Res5  thr D T y a0 x0 ITERALL NONZEROS NOISEP SigDim

%========================================================
% Experiment 1 - Extention - Average denoising effect 
%========================================================

clear all;
close all;
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
set(gca,'FontSize',14);
xlabel('Signal-to-Noise Ratio [dB]');
ylabel('Cardinality L');
title('Noise decay factor - 1 iteration');
colormap(gray(256)); colorbar; axis square;
set(gca,'FontSize',14);
hold on; 
contour(SNR,1:1:20,MAP1,20,'r');
print -depsc2 Case1_AverageDenoisingA.eps

figure(1); clf; 
imagesc(SNR,1:1:20,MAP3); 
set(gca,'FontSize',14);
xlabel('Signal-to-Noise Ratio [dB]');
title('Noise decay factor - 10 iterations');
colormap(gray(256)); colorbar; axis square;
set(gca,'FontSize',14);
hold on; 
contour(SNR,1:1:20,MAP3,20,'r');
print -depsc2 Case1_AverageDenoisingB.eps

figure(1); clf; 
imagesc(SNR,1:1:20,10*log10(MAP1./MAP3)); 
set(gca,'FontSize',14);
xlabel('Signal-to-Noise Ratio [dB]');
title('Improvement in SNR [dB]');
colormap(gray(256)); colorbar; axis square;
set(gca,'FontSize',14);
hold on; 
contour(SNR,1:1:20,10*log10(MAP1./MAP3),10,'r');
print -depsc2 Case1_AverageDenoisingC.eps
         
%========================================================
% Experiment 5 - Effect of dimensionality on the denoising performance
%========================================================

clear all;
close all;
ITERALL=40;
SigNUM=100;

count=1; ResF=zeros(10,ITERALL);
for SigDim=50:50:500;
    % Generate the dicitonary
    D=[];
    for k=1:1:5, D=[D,orth(randn(SigDim,SigDim))]; end;
    T=pinv(D);
    alpha=1/max(max(T'*T));

    % Generate the signals to test on
    NONZEROS=SigDim*0.1;
    thr=0.002:0.002:0.2;
    Res0=zeros(SigNUM,ITERALL);
    for signal=1:1:SigNUM,
        disp(signal);
        a0=zeros(5*SigDim,1);
        Pos=randperm(5*SigDim);
        a0(Pos(1:NONZEROS))=randn(NONZEROS,1);
        x0=D*a0;
        x0=x0/norm(x0);
        Noise=randn(SigDim,1);
        Noise=Noise/norm(Noise);
        y=x0+0.5*Noise;

        % Algorithm D for denoising - parallel CD - fixed mu
        ResTEMP=zeros(100,ITERALL);
        for k=1:1:100, % over the thresholds to apply
            a=zeros(5*SigDim,1);
            for Iter=1:1:ITERALL,
                aT=D'*(y-D*a)+a;
                aT=(aT-sign(aT)*thr(k)).*(abs(aT)>=thr(k));
                mu=1/alpha;
                a=a+mu*(aT-a);
                ResTEMP(k,Iter)=((D*a-x0)'*(D*a-x0))/((y-x0)'*(y-x0))/SigDim*50;
            end; % iterations           
        end; % thr
        pos=find(min(sum(ResTEMP'))==sum(ResTEMP'));
        Res0(signal,1:ITERALL)=ResTEMP(pos(1),:);
    end; % signals
    ResF(count,:)=mean(Res0);
    disp(ResF(:,end));
    count=count+1;
end;    
    
save EXPERIMENT6

figure(1); clf;
semilogy(ResF','b');
set(gca,'FontSize',14);
xlabel('Iteration');
ylabel('Noise decay factor(per sample)');
for k=1:1:10,
    h=text(30,ResF(k,30)*1.05,num2str(50*k));
    set(h,'FontSize',14);
end;
axis([0 40 0.04 1]);
grid on;
print -depsc2 DimensionRES.eps
    
%========================================================
% Experiment 6 - Effect of redundancy on the denoising performance
%========================================================

clear all;
close all;
ITERALL=40;
SigNUM=1;
SigDim=150;

count=1; ResF=zeros(5,ITERALL);
for Redundant=1:1:5,
    % Generate the dicitonary
    D=[];
    for k=1:1:Redundant, D=[D,orth(randn(SigDim,SigDim))]; end;
    T=pinv(D);
    alpha=1/max(max(T'*T));

    % Generate the signals to test on
    thr=0.002:0.002:0.2;
    Res0=zeros(SigNUM,ITERALL);
    for signal=1:1:SigNUM,
        disp(signal);
        a0=zeros(Redundant*SigDim,1);
        Pos=randperm(Redundant*SigDim);
        NONZEROS=round(SigDim*0.1/Redundant^0.5);
        a0(Pos(1:NONZEROS))=randn(NONZEROS,1);
        x0=D*a0;
        x0=x0/norm(x0);
        Noise=randn(SigDim,1);
        Noise=Noise/norm(Noise);
        y=x0+0.5*Noise;

        % Algorithm D for denoising - parallel CD - fixed mu
        ResTEMP=zeros(100,ITERALL);
        for k=1:1:100, % over the thresholds to apply
            a=zeros(Redundant*SigDim,1);
            for Iter=1:1:ITERALL,
                aT=D'*(y-D*a)+a;
                aT=(aT-sign(aT)*thr(k)).*(abs(aT)>=thr(k));
                mu=1/alpha;
                a=a+mu*(aT-a);
                ResTEMP(k,Iter)=((D*a-x0)'*(D*a-x0))/((y-x0)'*(y-x0));
            end; % iterations           
        end; % thr
        pos=find(min(sum(ResTEMP'))==sum(ResTEMP'))
        Res0(signal,1:ITERALL)=ResTEMP(pos(1),:);
    end; % signals
    ResF(count,:)=mean(Res0);
    disp(ResF(:,end));
    count=count+1;
end;    
    
save EXPERIMENT7

figure(1); clf;
semilogy(ResF(1:4,:)');
legend({'Redundancy factor=1','Redundancy factor=2','Redundancy factor=3','Redundancy factor=4'});
xlabel('Iterations');
ylabel('Noise decay factor');print -depsc2 DimensionRES.eps
    
    
    
    
