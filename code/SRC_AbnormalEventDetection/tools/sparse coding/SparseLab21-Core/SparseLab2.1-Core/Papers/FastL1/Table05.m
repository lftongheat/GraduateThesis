% Table05: Error and timing measurements for CS Reconstruction of Bumps 
% using Homotopy, Lars, OMP, and PFP.
%
% Data dependencies:
%   DataFigBumps.mat (Created by GenDataFigBumps.m)
%

load DataFigBumps.mat

fprintf('\n\n \\Homotopy\\ & %5.3f & %4.1f secs & %5.3f & %4.1f secs & %5.3f & %4.1f secs \\\\ \n', ...
    errHom(1), tHom(1), errHom(2), tHom(2), errHom(3), tHom(3));

fprintf('\\LARS\\ & %5.3f & %4.1f secs & %5.3f & %4.1f secs & %5.3f & %4.1f secs \\\\ \n', ...
    errLARS(1), tLARS(1), errLARS(2), tLARS(2), errLARS(3), tLARS(3));

fprintf('\\OMP\\ & %5.3f & %4.1f secs & %5.3f & %4.1f secs & %5.3f & %4.1f secs \\\\ \n', ...
    errOMP(1), tOMP(1), errOMP(2), tOMP(2), errOMP(3), tOMP(3));

fprintf('\\PFP\\ & %5.3f & %4.1f secs & %5.3f & %4.1f secs & %5.3f & %4.1f secs \\\\ \n', ...
    errPFP(1), tPFP(1), errPFP(2), tPFP(2), errPFP(3), tPFP(3));

