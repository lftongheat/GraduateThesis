%---------

%---------

clear;

%% Add path
addpath(genpath('tools/'));

%% Load training and testing data
% dataset
% UNM: scene1

load data/HOFFeatures_umn_scene1_0.8.mat;


% Normalization: normalize all samples with zero mean and unit variance
HOFFeaturesAvg = mean(HOFFeatures,1);
HOFFeatures = HOFFeatures-ones(size(HOFFeatures,1),1)*HOFFeaturesAvg;
HOFFeaturesNorm = sqrt( sum(HOFFeatures.^2,1) );
HOFFeatures = HOFFeatures./ (ones(size(HOFFeatures,1),1)*HOFFeaturesNorm);
        
trainSample = HOFFeatures(:,1:400);     %320*400
testSample = HOFFeatures(:,401:1449);   %320*1049

%% Learning dictionary from the training samples

% Parameters for dictionary learning
redundencyFactor = 2;                           % The number of the atoms = data dimension x redundencyFactor 
param.L = 10;                                   % The number of atoms used in representation a signal
param.InitializationMethod =  'DataElements';   % Initialize a dictionary with random sampling
param.errorFlag = 0;                            % Decompose signal without reaching an error bound
%param.K = redundencyFactor*size(trainSample,1); % The number of atoms in the dictionary
param.K = size(trainSample, 2);
param.numIteration = 5;                         % The number iteration for the K-SVD algorithm 
param.preserveDCAtom = 0;                       % Presearve a DC atom or not
param.displayProgress= 1;                       % Display the progress and the error at each iteration

% K-SVD dictionary learning
fprintf('K-SVD dictionary learning...\n');
[Dictionary,output] = KSVD(trainSample, param); 

%% Compute Sparse Reconstruction Cost using l1 minimization

sc_algo= 'l1magic';         % Select one sparse coding method
FastSparseCodingFag = 0;    % Use fast sparse coding
fprintf('Solving sparse coding...\n');

if(FastSparseCodingFag)
    [energy, offset, avgTime] = computeSRenergy(testSample, trainSample, Dictionary, param.L, sc_algo);
else
    [energy, offset, avgTime] = computeSRenergy0(testSample, trainSample, Dictionary, sc_algo);
end

% energy = [zeros(400,1);energy];
% offset = [zeros(400,1);offset];
%% graph show about the analysis result
label = {'401','601','801','1001','1201','1401','1601'};
figure(1)
subplot(2,1,1), plot(energy,'r')
title('sparse representation energy'),xlabel('energy')
set(gca,'xticklabel', label);
subplot(2,1,2), plot(offset,'b')
title('sparse representation offset'),xlabel('offset')
set(gca,'xticklabel', label);
%% 
% for i=1:1049
%     stem(X(:,i));
%     axis([0,400, -50, 50]);
%     title('coefficient graph');
%     framenum = ['frame ',num2str(i+400)];
%     xlabel(framenum);
%     pause;
% end
