%--------------------------------------------------------------
% This code generates Figure 4c of the following paper: 
% "Bayesian Compressive Sensing" (Preprint, 2007).
% The dataset used is similar to the one used in l1qc_example.m, 
% an example from l1magic. 
% Coded by: Shihao Ji, ECE, Duke University
% last change: Jan. 2, 2007
%--------------------------------------------------------------
clear all
%
load DataFig04cd_random.mat
rand_mean = mean(err);
rand_std = std(err);
load DataFig04cd_optimized.mat
opt_mean = mean(err);
opt_std = std(err);
load DataFig04cd_approx.mat
app_mean = mean(err);
app_std = std(err);
%
base = 40;
ns = 80;
dN = 1;
% plot the mean

plot(base+(1:ns)*dN,rand_mean,'b-o');
hold on;
plot(base+(1:ns)*dN,opt_mean,'r-*');
hold on;
plot(base+(1:ns)*dN,app_mean,'k-s');
xlabel('Number of Measurements'); ylabel('Reconstruction Error');
box on; axis([40,120,0,1.5]);
legend('Random','Optimized','Approx.',1);
