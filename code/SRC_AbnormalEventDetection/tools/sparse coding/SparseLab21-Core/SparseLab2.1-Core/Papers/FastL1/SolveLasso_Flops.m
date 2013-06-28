function [sols, numIters, activationHist, flops] = SolveLasso_Flops(A, y, algType, maxIters, fullPath, verbose, OptTol)
% SolveLasso_Flops: Computes the operation count of the Homotopy algorithm 
% when applied to solve the Lasso problem
% Usage
%	[sols, numIters, activationHist] = SolveLasso(A, y, algType, maxIters, fullPath, verbose, OptTol)
% Input
%	A           dxn matrix, with rank(A) = min(d,n) by assumption
%	y           d-vector
%   algType     'lars' for the original Lars algorithm, 
%               'lasso' for lars with the lasso modification (default)
%	maxIters    maximum number of Lars iterations to perform. If not
%               specified, runs to stopping condition (default)
%   fullPath    1 to return the entire solution path, 0 to return the final
%               solution (default)
%   verbose     1 to print out detailed progress at each iteration, 0 for
%               no output (default)
%	OptTol      Error tolerance, default 1e-5
% Outputs
%	sols           solution of BPDN problem
%	numIters       Total number of steps taken
%   activationHist Array of indices showing elements entering and 
%                  leaving the solution set
% Description
%   SolveLasso_Flops computes the operation count of the Lars/Lasso 
%   algorithm, as described by Efron et al. in "Least Angle Regression". 
% References
%   B. Efron, T. Hastie, I. Johnstone and R. Tibshirani, 
%   "Least Angle Regression", Annals of Statistics, 32, 407-499, 2004
% See Also
%   SolveLasso
%

[d,n] = size(A);

if nargin < 7,
    OptTol = 1e-5;
end
if nargin < 6,
    verbose = 0;
end
if nargin < 5,
    fullPath = 0;
end
if nargin < 4,
    maxIters = 100*n;
end
if nargin < 3,
    algType = 'lasso';
end

switch lower(algType)
    case 'lars'
        isLasso = 0;
    case 'lasso'
        isLasso = 1;
end

x = zeros(n,1);
iter = 0;

% Initialize flop count
flops = 0;

% Global variables for linsolve function
global opts opts_tr machPrec
opts.UT = true; 
opts_tr.UT = true; opts_tr.TRANSA = true;
machPrec = 1e-5;

% First vector to enter the active set is the one with maximum correlation
corr = A'*y;             
lambda = max(abs(corr)); 
newIndices = find(abs(abs(corr)-lambda) < machPrec)';    
%%% FLOPS %%%
flops = flops + d*n + n;

% Initialize Cholesky factor of A_I
R_I = [];
activeSet = [];
for j = 1:length(newIndices)
    iter = iter+1;
    if verbose
        fprintf('Iteration %d: Adding variable %d\n', iter, activeSet(j));
    end
    R_I = updateChol(R_I, A, activeSet, newIndices(j));
    activeSet = [activeSet newIndices(j)];
    %%% FLOPS %%%
    kk = length(activeSet)-1;
    flops = flops + kk*d + kk^2 + kk + d;
end

activationHist = activeSet;
collinearIndices = [];
sols = [];

done = 0;
while  ~done
    % Compute Lars direction - Equiangular vector
    dx = zeros(n,1);
    % Solve the equation (A_I'*A_I)dx_I = corr_I
    z = linsolve(R_I,corr(activeSet),opts_tr);
    dx(activeSet) = linsolve(R_I,z,opts);
    dmu = A'*(A(:,activeSet)*dx(activeSet));
    %%% FLOPS %%%
    flops = flops + 2*length(activeSet)^2 + length(activeSet)*d + n*d;

    % For Lasso, Find first active vector to violate sign constraint
    if isLasso
        zc = -x(activeSet)./dx(activeSet);
        gammaI = min([zc(zc > 0); inf]);
        removeIndices = activeSet(find(zc == gammaI));
        %%% FLOPS %%%
        flops = flops + length(activeSet);
    else
        gammaI = Inf;
        removeIndices = [];
    end

    % Find first inactive vector to enter the active set
    if (length(activeSet) >= min(d, n))
        gammaIc = 1;
    else
        inactiveSet = 1:n;
        inactiveSet(activeSet) = 0;
        inactiveSet(collinearIndices) = 0;
        inactiveSet = find(inactiveSet > 0);
        lambda = abs(corr(activeSet(1)));
        dmu_Ic = dmu(inactiveSet);
        c_Ic = corr(inactiveSet);

        epsilon = 1e-12; 
        gammaArr = [(lambda-c_Ic)./(lambda - dmu_Ic + epsilon) (lambda+c_Ic)./(lambda + dmu_Ic + epsilon)]';
        gammaArr(gammaArr < OptTol) = inf;
        gammaArr = min(gammaArr)';
        gammaIc = min(gammaArr);
        %%% FLOPS %%%
        flops = flops + 6*length(inactiveSet);
    end

    % If gammaIc = 1, we are at the LS solution
    if (1-gammaIc) < OptTol
        newIndices = [];
        %gammaIc = 1;
    else
        newIndices = inactiveSet(find(abs(gammaArr - gammaIc) < machPrec));
    end

    gammaMin = min(gammaIc,gammaI);

    % Compute the next Lars step
    x = x + gammaMin*dx;
    corr = corr - gammaMin*dmu;
    %%% FLOPS %%%
    flops = flops + 2*n;

    % Check stopping condition
    if (1-gammaMin) < OptTol
        done = 1;
    end

    % Add new indices to active set
    if (gammaIc <= gammaI) && (length(newIndices) > 0)
        for j = 1:length(newIndices)
            iter = iter+1;
            if verbose
                fprintf('Iteration %d: Adding variable %d\n', iter, newIndices(j));
            end
            % Update the Cholesky factorization of A_I
            [R_I, flag] = updateChol(R_I, A, activeSet, newIndices(j));
            % Check for collinearity
            if (flag)
                collinearIndices = [collinearIndices newIndices(j)];
                if verbose
                    fprintf('Iteration %d: Variable %d is collinear\n', iter, newIndices(j));
                end
            else
                activeSet = [activeSet newIndices(j)];
                activationHist = [activationHist newIndices(j)];
            end
            %%% FLOPS %%%
            kk = length(activeSet)-1;
            flops = flops + kk*d + kk^2 + kk + d;
        end
    end

    % Remove violating indices from active set
    if (gammaI <= gammaIc)
        for j = 1:length(removeIndices)
            iter = iter+1;
            col = find(activeSet == removeIndices(j));
            if verbose
                fprintf('Iteration %d: Dropping variable %d\n', iter, removeIndices(j));
            end
            % Downdate Cholesky factorization of A_I
            R_I = downdateChol(R_I,col);
            activeSet = [activeSet(1:col-1), activeSet(col+1:length(activeSet))];
            
            % Reset collinear set
            collinearIndices = [];

            %%% FLOPS %%%
            kk = length(activeSet)+1;
            flops = flops + 3*(kk-col)*(kk-col+1);
        end

        x(removeIndices) = 0;  % To avoid numerical errors
        activationHist = [activationHist -removeIndices];
    end

    if fullPath
        sols = [sols x];
    end
    
    if iter >= maxIters
        done = 1;
    end
end

if ~fullPath
    sols = x;
end

numIters = iter;
clear opts opts_tr machPrec


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [R, flag] = updateChol(R, A, activeSet, newIndex)
% updateChol: Updates the Cholesky factor R of the matrix 
% A(:,activeSet)'*A(:,activeSet) by adding A(:,newIndex)
% If the candidate column is in the span of the existing 
% active set, R is not updated, and flag is set to 1.

global opts_tr machPrec
flag = 0;

if length(activeSet) == 0,
    R = sqrt(sum(A(:,newIndex).^2));
else
    p = linsolve(R,A(:,activeSet)'*A(:,newIndex),opts_tr);
    q = sum(A(:,newIndex).^2) - sum(p.^2);
    if (q <= machPrec) % Collinear vector
        flag = 1;
    else
        R = [R p; zeros(1, size(R,2)) sqrt(q)];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function R = downdateChol(R, j)
% downdateChol: `Downdates' the cholesky factor R by removing the 
% column indexed by j.

% Remove the j-th column
R(:,j) = [];
[m,n] = size(R);

% R now has nonzeros below the diagonal in columns j through n.
% We use plane rotations to zero the 'violating nonzeros'.
for k = j:n
    p = k:k+1;
    [G,R(p,k)] = planerot(R(p,k));
    if k < n
        R(p,k+1:n) = G*R(p,k+1:n);
    end
end

% Remove last row of zeros from R
R = R(1:n,:);

