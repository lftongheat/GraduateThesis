% Reproduces Data for Figure 1 in "Sparse Nonnegative Solutions of Underdetermined
% Linear Equations by Linear Programming"

n=200;
mesh_rho=40;
rho=linspace(0.05,.999,mesh_rho);
mesh_delta=40;
delta=linspace(0.05,.999,mesh_delta);
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
save  SNSULELP rho delta test_sucesses tests_per_point

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
