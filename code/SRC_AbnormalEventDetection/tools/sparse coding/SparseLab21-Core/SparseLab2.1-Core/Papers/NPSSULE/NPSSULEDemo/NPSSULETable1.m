% Build table 1 for "High-Dimensional Centrosymmetric Polytopes with
% Neighborliness Proportional to Dimension"

warning off;

disp(sprintf('\n'))
disp(sprintf('%s','Table 1 from "Neighborly Polytopes and Sparse Solutions of'))
disp(sprintf('%s','Underdetermined Linear Equations" David Donoho, 2005')) 
disp(sprintf('\n'))
disp(sprintf('      | delta=.1 \t delta=.25 \t delta=.5 \t delta=.75 \t delta=.9'))
disp(sprintf('-----------------------------------------------------------------'))

% Solve for Rho_N

global newdelt
delta = [.1 .25 .5 .75 .9];
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
    %disp([d,rhostar])
end

disp(sprintf('rho_N | %4.3f \t \t %4.3f \t \t %4.3f \t \t %4.3f \t \t %4.3f', ...
    Neigh(1,2), Neigh(2,2), Neigh(3,2), Neigh(4,2), Neigh(5,2) ));

% Rho S

rhomax = 0.999;
rhomin = 0.005;
olddelta = 0.005;
SectNeigh = [];
for delta = [.1 .25 .5 .75 .9];
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
%  delta
SectNeigh = [SectNeigh; delta rhomin ];
end

disp(sprintf('rho_S | %4.3f \t \t %4.3f \t \t %4.3f \t \t %4.3f \t \t %4.3f', ...
    SectNeigh(1,2), SectNeigh(2,2), SectNeigh(3,2), SectNeigh(4,2), SectNeigh(5,2) ));

% Find Rho F

rhomax = 0.999;
rhomin = 0.005;
olddelta = 0.005;
FaceNeigh = [];
%mesh_density=100;
mesh_density = 1000;
for delta = linspace(0.0001,0.9999,mesh_density)
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
%  delta
FaceNeigh = [FaceNeigh; delta rhomin ];
end

disp(sprintf('rho_F | %4.3f \t \t %4.3f \t \t %4.3f \t \t %4.3f \t \t %4.3f', ...
    FaceNeigh(100,2), FaceNeigh(250,2), FaceNeigh(500,2), FaceNeigh(750,2), FaceNeigh(900,2) ));
disp(sprintf('-----------------------------------------------------------------'))

warning on;


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
