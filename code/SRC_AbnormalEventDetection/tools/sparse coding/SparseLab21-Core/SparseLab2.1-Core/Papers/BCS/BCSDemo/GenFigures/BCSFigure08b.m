%------------------------------------------------------
% This code generates Figure 8b of the following paper: 
% "Bayesian Compressive Sensing" (Preprint, 2007).
% Coded by: Shihao Ji, ECE, Duke University
% last change: June. 12, 2007
%------------------------------------------------------
clear all
%
load DataFig08b_random.mat
rand_mean = mean(err);
rand_std = std(err);
load DataFig08b_optimized.mat
opt_mean = mean(err);
opt_std = std(err);
%
base = 100+2099;
ns = 500;
dN = 1;
% 

plot(base+(1:ns)*dN,rand_mean,'b-');
hold on;
plot(base+(1:ns)*dN,opt_mean,'r:');
axis([2199,2700,0.13,0.305]);
xlabel('Number of Measurements'); ylabel('Reconstruction Error');
box on;
legend('Random','Optimized',1);
