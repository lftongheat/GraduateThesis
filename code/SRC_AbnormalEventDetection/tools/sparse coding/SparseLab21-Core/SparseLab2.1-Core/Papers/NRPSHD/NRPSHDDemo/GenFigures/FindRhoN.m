% Solve for Rho_N

global newdelt
mesh_density=100;
delta = linspace(.0001,0.999,mesh_density);
Neigh = [];
for d = delta,
     newdelt = d;

%zone=linspace(0.01,.99,100);

     if d < .12,
         limits = [1/500,1/15];
     elseif d< .5,
         limits = [1/20,1/6];
     else 
         limits = [1/12,1/2];
     end

%plot(zone,GenRhoNDiff(zone));
%pause

limits=[0.01,0.99];

    rhostar = fzero(@GenRhoNDiff,limits);
    Neigh = [ Neigh ; d rhostar ];
    disp([d,rhostar])
end
 figure;   
plot(Neigh(:,1),Neigh(:,2))
title('\rho_N(\delta)')
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
