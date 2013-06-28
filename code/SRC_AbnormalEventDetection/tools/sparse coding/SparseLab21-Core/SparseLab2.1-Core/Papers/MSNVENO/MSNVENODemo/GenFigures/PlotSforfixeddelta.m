function PlotSforfixeddelta(slice,strg);%ErrVecL2,col)

% takes the output of GenSW2log0z1_errbd and plots a 'slice' of the
% dataset, for a fixed delta value (delta == n/p)

% note this is the 3D output format (di,ki,ti) where di=delta_i, 
% k_i is the number of nonzero coefficients in the true vector, 
% and t_i is the trial number, from Dec 25 2005 onwards.

%slice = median(squeeze(ErrVecL2(col,:,:)),2)';

plot(linspace(0.05,1,50),slice,strg)

xlabel('\rho = k / n'); ylabel=('Error');

%
% Copyright (c) 2006. Victoria Stodden
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%