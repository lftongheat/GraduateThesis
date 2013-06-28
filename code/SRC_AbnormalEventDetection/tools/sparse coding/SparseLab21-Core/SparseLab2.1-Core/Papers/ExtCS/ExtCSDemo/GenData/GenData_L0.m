% GenData_L0: Generates data for figure 1, reconstruction error for 
% signals with controlled number of nonzeros.

M = 1024;

K = 20;
RunCS_L0;
save DataL0_20.mat M N E K

K = 50;
RunCS_L0;
save DataL0_50.mat M N E K

K = 100;
RunCS_L0;
save DataL0_100.mat M N E K

%
% Copyright (c) 2006. Yaakov Tsaig
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
