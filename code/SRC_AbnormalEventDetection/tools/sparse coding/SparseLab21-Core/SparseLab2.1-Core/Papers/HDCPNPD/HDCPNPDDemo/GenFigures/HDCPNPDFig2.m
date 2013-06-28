% Plot Rho F

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
% Plot Rho S

rhomax = 0.999;
rhomin = 0.005;
olddelta = 0.005;
SectNeigh = [];
mesh_density=500;
for delta = linspace(0.005,0.999,mesh_density)
rhomax = min(0.999,rhomax + 5.* (delta - olddelta));  % Assume drho/ddelta < 5
rhomin = max(0.005,rhomin - 5*(delta-olddelta));
olddelta = delta;
errtol = .00000001;
psitol = .000000001;
which=2;
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
SectNeigh = [SectNeigh; delta rhomin ];
end
plot(SectNeigh(:,1),SectNeigh(:,2),'g')

% Solve for Rho_N

global newdelt
delta = linspace(.0001,.9999,100);
Neigh = [];
for d = delta,
     newdelt = d;
     if d < .12,
         limits = [1/100,1/15];
     elseif d< .5,
         limits = [1/20,1/6];
     else 
         limits = [1/12,1/4];
     end
    rhostar = fzero(@GenRhoNDiff,limits);
    Neigh = [ Neigh ; d rhostar ];
    disp([d,rhostar])
end
plot(Neigh(:,1),Neigh(:,2),'r')
title('\rho_F(blue), \rho_S(green), \rho_N(red)')
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
