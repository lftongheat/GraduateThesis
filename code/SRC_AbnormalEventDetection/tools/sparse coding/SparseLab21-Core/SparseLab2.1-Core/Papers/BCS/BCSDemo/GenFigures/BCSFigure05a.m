%------------------------------------------------------
% This code generates Figure 5a of the following paper: 
% "Bayesian Compressive Sensing" (Preprint, 2007).
% Coded by: Shihao Ji, ECE, Duke University
% last change: June. 12, 2007
%------------------------------------------------------
clear all
%
load DataFig05a_random.mat
rand_mean = mean(err);
rand_std = std(err);
load DataFig05a_approx.mat
app_mean = mean(err);
app_std = std(err);
%
base = 40;
ns = 80;
dN = 1;
%

plot(base+(1:ns)*dN,rand_mean,'b-o');
hold on;
plot(base+(1:ns)*dN,app_mean,'k-s');
xlabel('Number of Measurements'); ylabel('Reconstruction Error');
box on;
axis([40,120,0,1.5]);
legend('Random (OMP)','Approx. (OMP)',1);

