%learning of local activity patterns by mppca
%get the posterior probability of each node optical flow vector

load OpticalFlowFeatures_pets.mat

[row,col] = size(mrf_features);
FeaturesPattern = cell(row, col);
MoFAs = cell(row, col);
Descriptors = cell(row, col);
frmbegin = 1000;frmend = 1450;
d = 36;%latent dimensionality
components = 3;%number of mixtuer components
for i=1:row
    for j=1:col
        disp(['featurepatterns-----mppca----',num2str(i),'----',num2str(j)]);
        nodeFeatures = mrf_features{i,j}(frmbegin:frmend,:);
        Descriptors{i,j} = mrf_features{i,j}(frmbegin:frmend,:);
        [LogL,MoFA,Q] = mfa(nodeFeatures',d,components,1,1,0);
        FeaturesPattern{i,j} = Q;
        MoFAs{i,j} = MoFA;
    end
end


save FeaturesPattern_pets.mat FeaturesPattern MoFAs Descriptors;


% load OpticalFlowFeatures_umn.mat
% 
% [row,col] = size(mrf_features);
% FeaturesPattern = cell(row, col);
% MoFAs = cell(row, col);
% Descriptors = cell(row, col);
% frmbegin = 1001;frmend = 1450;
% d = 36;%latent dimensionality
% components = 3;%number of mixtuer components
% K = 1;
% for frmnum=frmbegin+9:frmend
%     for i=1:row
%         for j=1:col
%             %disp(['featurepatterns-----mppca----',num2str(i),'----',num2str(j)]);
%             nodeFeatures = mrf_features{i,j}(frmbegin:frmnum,:);
%             [LogL,MoFA,Q] = mfa(nodeFeatures',d,components,1,1,0);
%             if K == 1
%                 FeaturesPattern{i,j} = Q;                
%             else                
%                 FeaturesPattern{i,j}(:,K+9) = Q(:,K+9);                
%             end
%             MoFAs{i,j}(K) = MoFA;
%         end
%     end
%     K=K+1;
% end
% 
% for i=1:row
%     for j=1:col
%         disp(['featurepatterns-----descriptors----',num2str(i),'----',num2str(j)]);
%         Descriptors{i,j} = mrf_features{i,j}(frmbegin:frmend,:);
%     end
% end
% 
% 
% save FeaturesPattern_update.mat FeaturesPattern MoFAs Descriptors;