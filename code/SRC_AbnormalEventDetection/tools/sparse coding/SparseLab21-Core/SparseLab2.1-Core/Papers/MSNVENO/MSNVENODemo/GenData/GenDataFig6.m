% Generates data to test Stepwise phase transition with noise
clear all;

p=200; n=100;
zi=1;
ErrVecL2n = RunSimulation0(n,p,zi,'Stepwise2logp');
save Fig6Datazi0 ErrVecL2n p n zi;
zi=1;
ErrVecL2n = RunSimulation(n,p,zi,'Stepwise2logp');
save Fig6Datazi1 ErrVecL2n p n zi;
zi=2;
ErrVecL2n = RunSimulation(n,p,zi,'Stepwise2logp');
save Fig6Datazi2 ErrVecL2n p n zi;
zi=4;
ErrVecL2n = RunSimulation(n,p,zi,'Stepwise2logp');
save Fig6Datazi4 ErrVecL2n p n zi;
zi=6;
ErrVecL2n = RunSimulation(n,p,zi,'Stepwise2logp');
save Fig6Datazi6 ErrVecL2n p n zi;
zi=9;
ErrVecL2n = RunSimulation(n,p,zi,'Stepwise2logp');
save Fig6Datazi9 ErrVecL2n p n zi;
zi=12;
ErrVecL2n = RunSimulation(n,p,zi,'Stepwise2logp');
save Fig6Datazi12 ErrVecL2n p n zi;
zi=16;
ErrVecL2n = RunSimulation(n,p,zi,'Stepwise2logp');
save Fig6Datazi16 ErrVecL2n p n zi;


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