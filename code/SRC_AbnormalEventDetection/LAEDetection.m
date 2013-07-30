%% Local Abnormal Event Detection
%UCSD Ped1 Dataset 
%The training set contains 34 short chips for learning of normal patterns
%The testing set contains 10 clips provided with abnormal events
%Each clip has 200 frames with a 158*238 resolution

clear
%% Add path
addpath(genpath('tools/'));

%% Load Features
load data\ucsd_ped1_test014_basis.mat
load data\ucsd_ped1_train_basis.mat

% Normalization: normalize all samples with zero mean and unit variance
trainbasisAvg = mean(train_basis{3,3},1);
trainbasis = train_basis{3,3}-ones(size(train_basis{3,3},1),1)*trainbasisAvg;
trainbasisNorm = sqrt( sum(trainbasis.^2,1) );
trainbasis = trainbasis./ (ones(size(trainbasis,1),1)*trainbasisNorm);
%trainbasis = trainbasis(:,1:400);

testbasisAvg = mean(test_basis{3,3},1);
testbasis = test_basis{3,3}-ones(size(test_basis{3,3},1),1)*testbasisAvg;
testbasisNorm = sqrt( sum(testbasis.^2,1) );
testbasis = testbasis./ (ones(size(trainbasis,1),1)*testbasisNorm);


%% Learning dictionary from the training samples

% Parameters for dictionary learning
redundencyFactor = 2;                           % The number of the atoms = data dimension x redundencyFactor 
param.L = 10;                                   % The number of atoms used in representation a signal
param.InitializationMethod =  'DataElements';   % Initialize a dictionary with random sampling
param.errorFlag = 0;                            % Decompose signal without reaching an error bound
param.K = redundencyFactor*size(trainbasis,1); % The number of atoms in the dictionary
%param.K = 400;
param.numIteration = 5;                         % The number iteration for the K-SVD algorithm 
param.preserveDCAtom = 0;                       % Presearve a DC atom or not
param.displayProgress= 1;                       % Display the progress and the error at each iteration

% K-SVD dictionary learning
fprintf('K-SVD dictionary learning...\n');
[Dictionary,output] = KSVD(trainbasis, param); 

%% Compute Sparse Reconstruction Cost using l1 minimization

sc_algo= 'l1magic';         % Select one sparse coding method
FastSparseCodingFag = 1;    % Use fast sparse coding
fprintf('Solving sparse coding...\n');

if(FastSparseCodingFag)
    [energy, offset, avgTime] = computeSRenergy(testbasis, trainbasis, Dictionary, param.L, sc_algo);
else
    [energy, offset, avgTime] = computeSRenergy0(testbasis, trainbasis, Dictionary, sc_algo);
end

%% graph show about the analysis result
figure(1)
subplot(2,1,1), plot(energy,'r')
title('sparse representation energy'),xlabel('energy')
%set(gca,'xticklabel', label3);
subplot(2,1,2), plot(offset,'b')
title('sparse representation offset'),xlabel('offset')

