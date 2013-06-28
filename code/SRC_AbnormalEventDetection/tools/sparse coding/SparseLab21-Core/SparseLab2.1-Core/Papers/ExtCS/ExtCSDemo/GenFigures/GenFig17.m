% Figure 17: Multiscale CS reconstrunction of Shepp-Logan phantom 
% in the curvelet domain, scale by scale images
% Uses Data file: CurveletMultiCSRes.mat
% See also: GenCurveletMultiCSRes

load CurveletMultiCSres.mat

for jj = (j0+2):(J-2)
    % Construct a vector of curvelet coeffs at scale jj
    theta = CI(jj - L + 2).coeff(:);
    Mdetail = length(theta);
    Ndetail = floor(Mdetail .* Narr(jj-j0));
    NCS = NCS + Ndetail;
    
    alpha = CCS(jj - L + 2).coeff(:);
    size(find(abs(theta) > 1e-2));

    subplot(2,1,1); 
    PlotSpikes(0,1:Mdetail,ShapeAsRow(theta)); title(['(a) Original signal at scale ' num2str(jj)]);
    subplot(2,1,2); PlotSpikes(0,1:Mdetail,ShapeAsRow(alpha)); title('(b) CS Reconstruction');
    disp([num2str(jj) ': n = ' num2str(Ndetail), ', ||E|| = ' num2str(twonorm(alpha - theta))]);
end

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
