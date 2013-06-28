%========================================================
% This demo presents a simple example for the case where a signal is
% generated as y=Da+n, where 
% D - a given redundant dictionary (built inside)
% a - a very sparse vector (built inside)
% n - additive noise (built inside). 
% 
% This demo shows how the iterated shrinkage algorithm is used to minimize
% the function
%    f(a) = || Da-y ||^2 + \lambda * || a ||_1
% The algorithm leads to very fast convergence. Furthermore, it is show
% that the final signal, D*a_est is a denoised version of y.
%========================================================

clear all;
close all;

%========================================================
% Construction of the data - a general 
%                  (random, non-tight and non-normalized) dictionary
%========================================================
SigDim=100; % dimension of the signal
Redundancy=10; % redundancy factor
D=randn(SigDim,Redundancy*SigDim);
for k=1:1:Redundancy*SigDim,
    D(:,k)=D(:,k)/norm(D(:,k))*(k/(Redundancy*SigDim)+0.5)/1.5;
end;

%========================================================
% Construction of the data - a sparse solution and signal
%========================================================
NONZEROS=10; % number of non-zeros in the representation
NOISEP=0.3; % the strength of the noise

a0=zeros(Redundancy*SigDim,1);
Pos=randperm(Redundancy*SigDim);
a0(Pos(1:NONZEROS))=randn(NONZEROS,1);
x0=D*a0;
y=x0+randn(SigDim,1)*NOISEP;

%========================================================
% Running the proposed Iterated Shrinkage Algorithm
%========================================================
ITERALL=15; % number of iterations 
lambda=0.25; % the parameter dictating the relative noise 

Res1=zeros(ITERALL+1,1); % the relative denoising effect
Res1(1)=(x0'*x0)/((y-x0)'*(y-x0)); 
Res2=zeros(ITERALL+1,1); % the value of the penalty function 
Res2(1)=0.5*y'*y;

w=1./diag(D'*D);
a=zeros(Redundancy*SigDim,1);
h=waitbar(0,'Iterating ... ');
for Iter=2:1:ITERALL+1,
    waitbar(Iter/(ITERALL+1));
    Da=D*a;
    aT=w.*(D'*(y-Da));
    aT=((aT+a)-sign(aT+a).*w.*lambda).*(abs(aT+a)>=lambda*w);
    delta=aT-a;
    Ddelta=D*delta;
    U=Ddelta'*(Da-y); V=Ddelta'*Ddelta;
    mu=5;
    for jj=1:1:10,
        Wtemp=diag(1./(abs(a+mu*delta)+1e-3));
        mu=-(U+2*lambda*delta'*Wtemp*a)/(V+2*lambda*delta'*Wtemp*delta);
    end;
    a=a+mu*delta;
    Res1(Iter)=((D*a-x0)'*(D*a-x0))/((y-x0)'*(y-x0));
    Res2(Iter)=0.5*(D*a-y)'*(D*a-y)+lambda*sum(abs(a));
end;
close(h);

figure(1); clf; plot(Res1); grid on;
xlabel('Iteration'); 
ylabel('Noise reduction factor');

figure(2); clf; plot(Res2); grid on;
xlabel('Iteration'); 
ylabel('Value of the Penalty Function');
