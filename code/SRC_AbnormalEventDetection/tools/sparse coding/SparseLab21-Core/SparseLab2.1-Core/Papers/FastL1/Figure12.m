% Figure12: The k-Sparse Solution Property for the USE.
%
% Data dependencies:
%   RhoDPlane-USE-Uniform-N1000.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-USE-Gaussian-N1000.mat (Created by GenDataRhoDPlane.m)
%   RhoDPlane-USE-Signs-N1000.mat (Created by GenDataRhoDPlane.m)
%   PFP-USE-Uniform-N1000.mat (Created by GenDataRhoDPlane.m)
%   PFP-USE-Gaussian-N1000.mat (Created by GenDataRhoDPlane.m)
%   PFP-USE-Signs-N1000.mat (Created by GenDataRhoDPlane.m)
%

GenFigL0Equiv('USE','Uniform',1000,0.25);
title('(a) Nonzero coefficient distribution U[0,1]');
GenFigL0Equiv('USE','Gaussian',1000,0.25);
title('(b) Nonzero coefficient distribution N[0,1]');
GenFigL0Equiv('USE','Signs',1000,0.25);
title('(c) Nonzero coefficient distribution random +/-1');
