% Figure03: (a) Operation Count of Homotopy as a fraction of one 
% solution of a least-squares problem.
% (b) Iteration diagram for Homotopy with the USE ensemble.
%
% Data Dependencies:
%   Flops-USE-Uniform-N1000.mat (Created by GenDataFigFlops.m)
%   RhoDPlane-USE-Uniform-N1000.mat (Created by GenDataRhoDPlane.m)
%   rhoF.mat 
%

Mat = 'USE';
In = 'Uniform';
n = 1000;
fname = ['Flops-' Mat, '-', In, '-N', num2str(n), '.mat'];
load(fname);

[Rho, Delta] = meshgrid(rhoArr, deltaArr);
D = floor(n.*Delta);

% Compute ratio to solution of full linear system
FlopsVec = median(FlopsVec,3);
FlopsVec = FlopsVec ./ (2.*D.^2.*n - 2.*D.^3./3);

load rhoF.mat
figure; 
pcolor(Delta,Rho,FlopsVec); 
caxis([0 5.05]);
colormap (1-gray); colorbar; shading interp; 
hold on; plot(deltaF, rhoF, '--r', 'LineWidth', 2); hold off;
xlabel('\delta = d/n'); ylabel('\rho = k/d'); 
title(['(a) Operation count as fraction of LS solution']);

GenFigIterChart(Mat,In,n,0.25);
title(['(b) No. iterations as a fraction of d = \delta{n}']);

