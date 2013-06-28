% This script generates the Figure 3. Please
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

thr0=0.3;
Fnc=zeros(4,50);
a=ones(10*SigDim,1);
Fnc(:,1)=0.5*y'*y; (D*a-y)'*(D*a-y)+thr0*sum(abs(a));

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
a=ones(10*SigDim,1);
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

figure(6); clf; % This is Figure 3 in the paper
h=semilogy(Fnc(1,:),'b-.');
set(h,'LineWidth',2); 
set(gca,'FontSize',16);
hold on;
h=xlabel('Iteration');
set(h,'FontSize',16);
h=ylabel('Objective function value');
set(h,'FontSize',16);
h=semilogy(Fnc(2,:),'b');
set(h,'LineWidth',2); 
h=semilogy(Fnc(3,:),'b--');
set(h,'LineWidth',2); 
h=semilogy(Fnc(4,:),'b:');
set(h,'LineWidth',2); 
axis([0 50 0 500]);
grid on;
h=legend({'IRLS','Sequential Shrinkage',...
    'Parallel Shrinkage - fixed \mu','Parallel Shrinkage with line-search'});
set(h,'FontSize',16);
