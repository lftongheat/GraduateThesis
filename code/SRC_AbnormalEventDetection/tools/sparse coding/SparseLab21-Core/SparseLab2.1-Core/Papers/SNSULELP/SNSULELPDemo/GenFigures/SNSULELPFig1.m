% Reproduces Figure 1 in "Sparse Nonnegative Solutions of Underdetermined
% Linear Equations by Linear Programming"

reply = input('Do you want to use the existing dataset? (creating it yourself could take many hours) Y/N [Y]: ', 's');
if isempty(reply)
    reply = 'Y';
end

rhomax = 0.999;
rhomin = 0.005;
olddelta = 0.005;
FaceNeigh = [];
mesh_density=100;
for delta = linspace(0.005,0.999,mesh_density)
rhomax = min(0.999,rhomax + 5.* (delta - olddelta));  % Assume drho/ddelta < 5
rhomin = max(0.005,rhomin - 5*(delta-olddelta));
olddelta = delta;
errtol = .000001;
psitol = .0000001;
which=3;
refine=1;
refine_steps=1;
while( rhomax - rhomin > errtol),
    newrho = (rhomax + rhomin)/2;
    nu = linspace(delta, min(.9999999, delta+0.1),200);
    Psi = PsiNet(nu,newrho,delta,which);
    if refine==1
      for m=1:refine_steps
        j=1;
        while (Psi(j+1)>=Psi(j) & j+1<length(Psi)),
          j=j+1;
        end
        deltanu=nu(2)-nu(1);
        nu = linspace(max(delta,nu(j)-5*deltanu),min(0.9999,nu(j+1)+5*deltanu),200);
        Psi = PsiNet(nu,newrho,delta,which);
      end
    end
%      plot(nu,Psi)
%      [delta, rhomin, rhomax]
%      pause
    if all(Psi < -psitol),
        rhomin = newrho;
    else
        rhomax = newrho;
    end
%    [delta,rhomin,rhomax]
end
  delta
%  [delta, rhomin]
FaceNeigh = [FaceNeigh; delta rhomin ];
end

n=200;
mesh_rho=40;
rho=linspace(0.05,.999,mesh_rho);
mesh_delta=40;
delta=linspace(0.05,.999,mesh_delta);

if reply == 'Y',
    load('GenData/SNSULELP.mat');
end

if reply == 'N',
    test_sucesses=zeros(mesh_rho,mesh_delta);

    threshold=10^(-7);
    tests_per_point=50;

    for tt=1:tests_per_point
        for q=1:mesh_rho
            for p=1:mesh_delta
                d=max(1,floor(delta(p)*n));
                A=rand(d,n);

                %FOR RANDOM ORTHO-PROJECTOR
                %for k=1:d
                %  for j=k:d
                %    A(j,:)=A(j,:)/norm(A(j,:),2);
                %  end
                %  for j=k+1:d
                %    A(j,:)=A(j,:)-sum(A(k,:).*A(j,:))*A(k,:);
                %  end
                %end

                x=zeros(n,1);
                x(1:max(1,floor(rho(q)*delta(p)*n)))=rand(max(1,floor(rho(q)*delta(p)*n)),1);

                [junk shuffle_index]=sort(rand(size(x)));
                x=x(shuffle_index);
                b=A*x;

                x0 = linprog(ones(size(x)),[],[],A,b,zeros(size(x)),ones(size(x)));
                error=norm(x-x0,2)/norm(x,2);

                if error<threshold
                    test_sucesses(q,p)=test_sucesses(q,p)+1;
                end
            end
        end
    end
end

contour(rho,delta,test_sucesses/tests_per_point,20)
xlabel('\delta')
ylabel('\rho_F')
colorbar
colormap bone

hold on
plot(FaceNeigh(:,1),FaceNeigh(:,2))

%
% Copyright (c) 2006. David Donoho
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
