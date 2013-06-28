function [xest]=Ortho_Matching_Pursuit(S,D,Var)

%=========================================================
% This function applies the Orthonormal Matching Pursuit in order 
% to approximate the solution of 
%
%               Min ||x||_1 subject to: ||Dx-S||_2<Var
%
% Input:   S - the signal to decompose
%             D - the dictionary
%             Var - the error in representation
%
% Output: xest - the result of the minimization task
%
%
%=========================================================

debug=0;
if debug==1, 
    N=128; NonZeros=4;
    H0=1/sqrt(2)*[1 1 ; -1 1];
    H=H0;
    for k=1:1:log(N)/log(2)-1, 
        H=kron(H,H0);
    end;
    D=[H,eye(N)];
    Flag=rand(2*N,1);
    SFlag=sort(Flag);
    Thr=(SFlag(2*N-NonZeros+1)+SFlag(2*N-NonZeros))/2;
    Flag=Flag>Thr;        
    x=randn(2*N,1);
    x=x.*Flag;
    S0=D*x;
    Var=rand;
    Noise=randn(N,1);
    Noise=sqrt(Var)*Noise/sqrt(sum(Noise.^2));
    S=S0+Noise;
end;

[N,L]=size(D);
xest=zeros(L,1);
Flag=xest;
Err=D*xest-S;

while Err'*Err>Var, 
    Projection=abs(D'*Err);
    pos=find(Projection==max(Projection));
    pos=pos(1);
    Flag(pos)=1;
    xest(find(Flag))=pinv(D(:,find(Flag)))*S;
    Err=D*xest-S;
    % disp(Err'*Err);
end;