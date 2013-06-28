% This script generates the three figures that compose Figure 6. Please
% note that since this experiment is using a random dictionary, the figures
% may show slight deviation from the paper's figure. 

%clear all;
%close all;
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
end;%figure(1); clf;

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
%figure(1); clf;
h=plot(thr,Res1,'b');
set(h,'LineWidth',2); 
set(gca,'FontSize',16);
hold on;
h=plot(thr,Res2(:,1),':');
set(h,'LineWidth',2); 
h=plot(thr,Res2(:,5),'--');
set(h,'LineWidth',2); 
axis([0 1 0 2.5]);
h=legend({'Simple Shrinkage','IRLS - 1st iteration','IRLS - 5th iteration'},1);
set(h,'FontSize',16);
h=xlabel('\lambda');
set(h,'FontSize',16);
h=ylabel('Noise decay factor');
set(h,'FontSize',16);
h=title('IRLS versus simple shrinkage');
set(h,'FontSize',16);
grid on;

