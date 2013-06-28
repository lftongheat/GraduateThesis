%------------------------------------------------------
% This code generates Figure 8a of the following paper: 
% "Bayesian Compressive Sensing" (Preprint, 2007).
% Coded by: Shihao Ji, ECE, Duke University
% last change: June. 12, 2007
%------------------------------------------------------
clear all
%
load DataFig08a_random.mat
rand_mean = mean(err);
rand_std = std(err);
load DataFig08a_optimized.mat
opt_mean = mean(err);
opt_std = std(err);
%
base = 650+4^3;
ns = 200;
dN = 1;
% 

plot(base+(1:ns)*dN,rand_mean,'b-');
hold on;
plot(base+(1:ns)*dN,opt_mean,'r:');
axis([714,915,0.21,0.53]);
xlabel('Number of Measurements'); ylabel('Reconstruction Error');
box on;
legend('Random','Optimized',1);
