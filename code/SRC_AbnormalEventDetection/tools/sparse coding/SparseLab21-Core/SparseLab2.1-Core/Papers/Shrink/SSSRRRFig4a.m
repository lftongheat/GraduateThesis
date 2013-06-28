% This script generates the four figures that compose Figure 4. Please
% note that since this experiment is using a random dictionary, the figures
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
%figure(1); clf; % The first part of Figure 4
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
