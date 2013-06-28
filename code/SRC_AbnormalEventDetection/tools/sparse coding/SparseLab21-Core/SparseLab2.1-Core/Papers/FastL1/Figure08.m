% Figure 08: k-step solution property of Homotopy with the partial 
% Fourier ensemble. 
% 
% Data dependencies:
%   RhoDPlane-RST-Uniform-N1024.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-RST-Gaussian-N1024.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-RST-Signs-N1024.mat (Created by GenDataRhoDPlane.m)
%

GenFigRhoDPlane('RST','Uniform',1024,0.25);
title('(a) PFE with random coefficients U[0,1]'); 
GenFigRhoDPlane('RST','Gaussian',1024,0.25);
title('(b) PFE with random coefficients N[0,1]'); 
GenFigRhoDPlane('RST','Signs',1024,0.25);
title('(c) PFE with random coefficients +/-1'); 
