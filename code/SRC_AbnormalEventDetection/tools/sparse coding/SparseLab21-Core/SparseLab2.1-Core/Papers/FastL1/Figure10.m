% Figure10: Estimated Phase Transition Curves.
% Each panel displays empirical phase transition curves
% for the PFE (solid), PHE (dashed), URPE (dash-dotted), with
% (a) Uniform nonzero distribution; (b) Gaussian nonzero distribution;
% (c) Bernoulli nonzero distribution. 
%
% Data dependencies:
%   RhoDPlane-RST-Uniform-N1024.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-RST-Gaussian-N1024.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-RST-Signs-N1024.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-Hadamard-Uniform-N1024.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-Hadamard-Gaussian-N1024.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-Hadamard-Signs-N1024.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-URP-Uniform-N1000.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-URP-Gaussian-N1000.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-URP-Signs-N1000.mat (Created by GenDataRhoDPlane.m)
%


close all;
warning off all;
coeffs = {'Uniform','Gaussian','Signs'};
titles = {'(a) Uniform nonzero distribution', '(b) Gaussian nonzero distribution', ...
    '(c) Bernoulli nonzero distribution'};

for ii = 1:3
    figure; 
    
    [delta,rho] = EmpTransitionRhoDPlane('RST',coeffs{ii},1024,0.25);
    hold on; plot(delta,rho,'-b','LineWidth',2); hold off;

    [delta,rho] = EmpTransitionRhoDPlane('Hadamard',coeffs{ii},1024,0.25);
    hold on; plot(delta,rho,'--g','LineWidth',2); hold off;

    [delta,rho] = EmpTransitionRhoDPlane('URP',coeffs{ii},1000,0.25);
    hold on; plot(delta,rho,'-.r','LineWidth',2); hold off;

    xlabel('\delta = d/n'); ylabel('\rho = k/d');
    title(titles{ii});
    grid on; axis([0.1 1 0 1]);
    legend('PFE','PHE','URPE','Location','NorthWest');
end

