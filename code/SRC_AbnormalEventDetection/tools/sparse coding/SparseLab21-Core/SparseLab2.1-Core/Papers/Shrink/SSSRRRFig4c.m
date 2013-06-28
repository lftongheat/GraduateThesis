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
%figure(3); clf; % The third part of Figure 4
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

