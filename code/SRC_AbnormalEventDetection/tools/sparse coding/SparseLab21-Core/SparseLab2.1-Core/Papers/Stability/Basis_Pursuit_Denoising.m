function [xest]=Basis_Pursuit_Denoising(S,D,Var,xtrue,Iter,alpha,pow)

%=========================================================
% This function solves      Min ||x||_1 subject to: ||Dx-S||_2<Var
%
% Input:   N - size of the signal to be treated
%             S - the signal to decompose
%             D - the dictionary
%             Var - the error in representation
%             xinit - initialization result
%             Iter - Number of iterations in the IRLS
%             alpha - relaxation parameter
%             pow - the power to use in 
%
% Output: xest - the result of the minimization task
%
%
%=========================================================

DD=D'*D;
if nargin==4,
    Iter=10; alpha=0.05; pow=12;
end;

[N,L]=size(D);
xest=xtrue;
lambda=1;
for k=1:1:Iter,
    W=spdiags(1./(abs(xest)+1e-8),0,L,L);
    xest=(1-alpha)*inv(W+lambda*DD)*lambda*D'*S+alpha*xest;
end;
Err=D*xest-S;

count=1;
Temp_Res=zeros(30,2);
Temp_Res(1,:)=[Err'*Err,1];

while abs(Err'*Err-Var)>1e-4 & count<50,
    Ratio=(Err'*Err)/Var;
    lambda=lambda*max(min(Ratio^pow,10),1.001);
    xest=xtrue;
    for k=1:1:Iter, 
        W=spdiags(1./(abs(xest)+1e-8),0,L,L);
        xest=(1-alpha)*inv(W+lambda*DD)*lambda*D'*S+alpha*xest;
    end;
    Err=D*xest-S;
    count=count+1;
    Temp_Res(count,:)=[Err'*Err,lambda];
    % disp([Err'*Err,lambda]);
end;

if count==30,
    pos=find(abs(Var-Temp_Res(:,1))==min(abs(Var-Temp_Res(:,1))));
    if abs(Temp_Res(pos(1),1)-Var)<1e-4, 
        lambda=Temp_Res(pos(1),2);
        xest=xtrue;
        for k=1:1:Iter, 
            W=spdiags(1./(abs(xest)+1e-8),0,L,L);
            xest=(1-alpha)*inv(W+lambda*DD)*lambda*D'*S+alpha*xest;
        end;        
    else, 
        xest=-1;
    end;
end;

return;

































OPTIONS=optimset('Display','Off','Diagnostics','off','LargeScale','off');
[N,L]=size(D);

% % solving the exact equality constraint for initialization
% 
% f=ones(4*N,1);
% Aeq=[D -D];
% Beq=S;
% xinit=[xtrue.*(xtrue>0); xtrue.*(xtrue<=0)];
% xest=linprog(f,[],[],Aeq,Beq,0*f,[],xinit,OPTIONS);
% if Var<1e-7, 
%     xest=xest(1:L)-xest(L+1:2*L);
%     return;
% end;

% prepartion of arrays for the QP part
H=eye(2*L+N)*1e-5;
H(2*L+1:end,2*L+1:end)=eye(N);
f=[ones(2*L,1); zeros(N,1)];
Aeq=[D, -D, -eye(N)];
Beq=S;
LB=[zeros(2*L,1); -10000*ones(N,1)];
xinit=[xtrue.*(xtrue>0); -xtrue.*(xtrue<=0); D*xtrue-S];

% step 1 - try 2 extremely different values of lambda
lambda1=1e-3;
res=quadprog(lambda1*H/2,f,[],[],Aeq,Beq,LB,[],xinit,OPTIONS);
Var1=sum(res(2*L+1:end).^2);
lambda2=100;
res=quadprog(lambda2*H/2,f,[],[],Aeq,Beq,LB,[],xinit,OPTIONS);
Var2=sum(res(2*L+1:end).^2);

% step 2 - around the best result, try another 10 values
Deviation=min(abs([Var1,Var2]-Var));
% figure(10); clf; loglog(Var1,lambda1,'+'); hold on; loglog(Var2,lambda2,'+');
while Deviation>1e-4, 
    % predict the next lambda value
    slope=(log(lambda2)-log(lambda1))/(log(Var2)-log(Var1));
    lambda=exp(slope*(log(Var)-log(Var1))+log(lambda1));
    % solve for the new lambda
    res=quadprog(lambda*H/2,f,[],[],Aeq,Beq,LB,[],xinit,OPTIONS);
    Var_new=sum(res(2*L+1:end).^2);
    % loglog(Var_new,lambda,'+'); drawnow;
    if Var_new>Var, 
        Var1=Var_new; lambda1=lambda;
    else, 
        Var2=Var_new; lambda2=lambda;
    end;
    disp([Var,Var_new]);
    Deviation=min(abs([Var1,Var2]-Var));
    % disp([Var1,Var2,lambda1,lambda2]);
end;
xest=res(1:L)-res(L+1:2*L);

return;
    
