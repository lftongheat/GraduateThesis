% This script generates the four figures that compose Figure 4. Please
% note that since this experiment is using a random dictionary, the figures
% may show slight deviation from the paper's figure. 

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
figure(1); clf; % The first part of Figure 4
h=plot(thr,Res1,'b');
set(h,'LineWidth',2); 
set(gca,'FontSize',16);
hold on;
h=plot(thr,Res2(:,1),':');
set(h,'LineWidth',2); 
h=plot(thr,Res2(:,5),'--');
set(h,'LineWidth',2); 
axis([0 1 0.3 1.3]);
grid on;
h=legend({'Simple Shrinkage','IRLS - 1st iteration','IRLS - 5th iteration'},2);
set(h,'FontSize',16);
h=xlabel('\lambda');
set(h,'FontSize',16);
h=ylabel('Noise decay factor');
set(h,'FontSize',16);
h=title('IRLS versus simple shrinkage');
set(h,'FontSize',16);

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
figure(2); clf; % The second part of Figure 4
h=plot(thr,Res1,'b');
set(h,'LineWidth',2); 
set(gca,'FontSize',16)
hold on;
h=plot(thr,Res3(:,1),':');
set(h,'LineWidth',2); 
h=plot(thr,Res3(:,5),'--');
set(h,'LineWidth',2); 
axis([0 1 0.3 1.3]);
grid on;
h=legend({'Simple Shrinkage','Sequential Shrinkage - 1st iteration',...
    'Sequential Shrinkage - 5th iteration'},2);
set(h,'FontSize',16);
h=xlabel('\lambda');
set(h,'FontSize',16);
h=ylabel('Noise decay factor');
set(h,'FontSize',16);
h=title('Sequential Shrinkage versus simple shrinkage');
set(h,'FontSize',16);

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
figure(3); clf; % The third part of Figure 4
h=plot(thr,Res1,'b');
set(h,'LineWidth',2); 
set(gca,'FontSize',16);
hold on;
h=plot(thr,Res4(:,1),'.');
set(h,'LineWidth',2); 
h=plot(thr,Res4(:,5),'--');
set(h,'LineWidth',2); 
axis([0 1 0.3 1.3]);
grid on; 
h=legend({'Simple Shrinkage','parallel Shrinkage - 1st iteration',...
    'Parallel Shrinkage - 5th iteration'},2);
set(h,'FontSize',16);
h=xlabel('\lambda');
set(h,'FontSize',16);
h=ylabel('Noise decay factor');
set(h,'FontSize',16);
h=title('Parallel Shrinkage (Fixed \mu=1/\alpha) versus simple shrinkage');

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
figure(4); clf; % The fourth part of Figure 4
h=plot(thr,Res1,'b');
set(h,'LineWidth',2); 
set(gca,'FontSize',16);
hold on;
h=plot(thr,Res5(:,1),'.');
set(h,'LineWidth',2); 
h=plot(thr,Res5(:,5),'--');
set(h,'LineWidth',2); 
axis([0 1 0.3 1.3]); grid on;
h=legend({'Simple Shrinkage','Parallel Shrinkage - 1st iteration',...
    'Parallel Shrinkage - 5th iteration'},2);
set(h,'FontSize',16);
h=xlabel('\lambda');
set(h,'FontSize',16);
h=ylabel('Noise decay factor');
set(h,'FontSize',16);
h=title('Parallel Shrinkage (+Line-Search) versus simple shrinkage');
set(h,'FontSize',16);

