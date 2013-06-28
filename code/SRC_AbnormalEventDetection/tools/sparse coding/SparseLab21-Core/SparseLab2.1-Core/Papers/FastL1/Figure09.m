% Figure 09: k-step solution property of Homotopy with the partial 
% Fourier ensemble, for fixed delta = 0.5.
% 
% Data dependencies:
%   RhoNPlane-RST-Uniform-N1024.mat (Created by GenDataRhoNPlane.m)
%   RhoNPlane-RST-Gaussian-N1024.mat (Created by GenDataRhoNPlane.m)
%   RhoNPlane-RST-Signs-N1024.mat (Created by GenDataRhoNPlane.m)
%


GenFigRhoNPlane('RST','Uniform',0.5,0.25);
title('(a) PFE with random nonzeros U[0,1]'); 
GenFigRhoNPlane('RST','Gaussian',0.5,0.25);
title('(b) PFE with random nonzeros N[0,1]'); 
GenFigRhoNPlane('RST','Signs',0.5,0.25);
title('(c) PFE with random nonzeros +/-1'); 
