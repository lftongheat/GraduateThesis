% Figure13: The k-Sparse Solution Property for the URPE.
%
% Data dependencies:
%   RhoDPlane-URP-Uniform-N1000.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-URP-Gaussian-N1000.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-URP-Signs-N1000.mat (Created by GenDataRhoDPlane.m)
%

GenFigL0Equiv('URP','Uniform',1000,0.25);
title('(a) Nonzero coefficient distribution U[0,1]');
GenFigL0Equiv('URP','Gaussian',1000,0.25);
title('(b) Nonzero coefficient distribution N[0,1]');
GenFigL0Equiv('URP','Signs',1000,0.25);
title('(c) Nonzero coefficient distribution random +/-1');
