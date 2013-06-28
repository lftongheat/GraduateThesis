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
