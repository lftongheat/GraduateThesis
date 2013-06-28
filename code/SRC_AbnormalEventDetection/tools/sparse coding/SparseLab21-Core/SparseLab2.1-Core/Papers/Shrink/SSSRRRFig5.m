% This script generates the Figure 5. Please note that since this 
% experiment is using a random dictionary, the figures
% may show slight deviation from the paper's figure. 

%clear all;
%close all;
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

%figure(5); clf; % this part generates Figure 5
h=plot(thr,Mu_all);
set(h,'LineWidth',2); 
set(gca,'FontSize',16);
h=xlabel('\lambda');
set(h,'FontSize',16);
h=ylabel('Optimal first iteration \mu');
set(h,'FontSize',16);
grid on;
