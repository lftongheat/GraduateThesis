%learning of local activity patterns by mppca
%get the posterior probability of each node optical flow vector

load OpticalFlowFeatures.mat

[row,col] = size(mrf_features);
FeaturesPattern = cell(row, col);
frmbegin = 1001;frmend = 1450;
d = 36;%latent dimensionality
components = 3;%number of mixtuer components
for i=1:row
    for j=1:col
        disp(['featurepatterns-----mppca----',num2str(i),num2str(j)]);
        nodeFeatures = mrf_features{i,j}(frmbegin:frmend,:);
        [LogL,MoFA,Q] = mfa(nodeFeatures',d,components,1,1,0);
        FeaturesPattern{i,j} = Q;
    end
end


save FeaturesPattern.mat FeaturesPattern;