% GenCurveletMultiCSRes: Generates data for figure 16, Multiscale CS
% reconstrunction of Shepp-Logan phantom in the curvelet domain.


close all;

J = 9;
n = 2^J;

I0 = phantom('Modified Shepp-Logan', n);

% Set finest, coarsest scales
L = 4;
j1 = 7;
j0 = 4;

% Linear sampling by measuring coarse scale coeffs
CI = Curvelet02Xform(I0, L);
Clin = ZeroCurveletTree(n, L);
Nlin = 0;
for jj = (L-1):j1
    Clin(jj - L+2).coeff = CI(jj - L+2).coeff;
    Nlin = Nlin + prod(size(CI(jj - L+2).coeff));
end
Ilin = Inv_Curvelet02Xform(Clin, L);
Elin = twonorm(I0 - Ilin) / twonorm(I0);

% Now, do CS scheme, scale by scale
% Sample 2^j0 coarse-scale coeffs
CCS = ZeroCurveletTree(n, L);
NCS = 0;
for jj = (L-1):j0
    CCS(jj - L+2).coeff = CI(jj - L+2).coeff;
    NCS = NCS + prod(size(CI(jj - L+2).coeff));
end

Narr = [0.5 0.25 0.1 0.1];

% For each scale, apply CS scheme
for jj = (j0+1):(J-1)
    % Construct a vector of curvelet coeffs at scale jj
    theta = CI(jj - L + 2).coeff(:);
    Mdetail = length(theta);
    Ndetail = floor(Mdetail .* Narr(jj-j0));
    NCS = NCS + Ndetail;
    
    % Solve the CS problem
    alpha = SolveFastCS(theta, Ndetail);
    
    CCS(jj - L + 2).coeff = reshape(alpha, size(CI(jj - L + 2).coeff));
    
    %alpha = CCS(jj - L + 2).coeff(:);
    %size(find(abs(theta) > 1e-2))

    %figure; subplot(2,1,1); 
	%PlotSpikes(0,1:Mdetail,ShapeasRow(theta)); title(['Scale ' num2str(jj)]);
    %subplot(2,1,2); PlotSpikes(0,1:Mdetail,ShapeasRow(alpha));
    %title(['n = ' num2str(Ndetail), ', ||E|| = ' num2str(twonorm(alpha - theta))]);
end

% Reconstruct and compute error
ICS = Inv_Curvelet02Xform(CCS, L);
ECS = twonorm(I0 - ICS) / twonorm(I0);

% Finally, do best N-term approximation
Cv = CurveletToVec(CI);
Cvr = reverse(sort(abs(Cv)));
thresh = Cvr(NCS);
CurvInd = find(abs(Cv) >= thresh);
Nbest = length(CurvInd);
Cm = zeros(size(Cv));
Cm(CurvInd) = Cv(CurvInd);
Cbest = VecToCurvelet(Cm, n, L);
Ibest = Inv_Curvelet02Xform(Cbest, L);

Ebest = twonorm(I0 - Ibest) / twonorm(I0);

save CurveletMultiCSRes.mat

%
% Copyright (c) 2006. Yaakov Tsaig
%  

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
