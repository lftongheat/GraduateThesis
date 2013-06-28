% Figure 1: The theoretical threshold at which the l_1 approximation to the
% l_0 optimization problem no longer holds. The curve delineates a Phase
% Transition from the lower region where the approximation holds, to the 
% upper region, where we are forced to use combinatorial search to recover
% the optimal sparse model. Along the x-axis the level of underdeterminedness
% decreases, and along the y-axis the level of sparsity of the underlying
% model increases.

rhomax = 0.999;
rhomin = 0.005;
olddelta = 0.005;
FaceNeigh = [];
mesh_density=100;
for delta = linspace(0.005,0.999,mesh_density)
rhomax = min(0.999,rhomax + 5.* (delta - olddelta));  % Assume drho/ddelta < 5
rhomin = max(0.005,rhomin - 5*(delta-olddelta));
olddelta = delta;
errtol = .00001;
psitol = .000001;
which=3;
refine=1;
refine_steps=2;
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
FaceNeigh = [FaceNeigh; delta rhomin ];
end

hold on
plot(FaceNeigh(:,1),FaceNeigh(:,2))
xlabel('\delta')


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