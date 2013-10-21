
%---------

%---------

clear;

%% Add path
addpath(genpath('tools/'));

%% Load training and testing data
% dataset
% UNM: scene1


disp('load data');
%load data/HOFFeatures_umn_scene1_0.8.mat;
% load data/HOFFeatures_umn_scene2_0.8.mat;
load data/HOFFeatures_umn_scene3_0.8.mat;

disp('Normalization');
% Normalization: normalize all samples with zero mean and unit variance
HOFFeaturesAvg = mean(HOFFeatures,1);
HOFFeatures = HOFFeatures-ones(size(HOFFeatures,1),1)*HOFFeaturesAvg;
HOFFeaturesNorm = sqrt( sum(HOFFeatures.^2,1) );
HOFFeatures = HOFFeatures./ (ones(size(HOFFeatures,1),1)*HOFFeaturesNorm);

%scene1
% scene_start = 1;
% scene_end = 1449;
%scene2
% scene_start = 1455;
% scene_end = 5594;
%scene1
scene_start = 5600;
scene_end = 7738;

%
trainSample = HOFFeatures(:,scene_start:scene_start+400-1);     %320*400
%testSample = HOFFeatures(:,scene_start+401:scene_end);   %320*
testSample = HOFFeatures(:,scene_start:scene_end);   %320*

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
FastSparseCodingFag = 1;    % Use fast sparse coding
fprintf('Solving sparse coding...\n');

% if(FastSparseCodingFag)
%     [energyReduce, avgTime] = computeSRenergy(testSample, trainSample, Dictionary, param.L, sc_algo);
% else
%     [energy, avgTime] = computeSRenergy0(testSample, trainSample, Dictionary, sc_algo);
% end

%run the common sparse coding
[energy, avgTime0, abnormalframe] = computeSRenergy0(testSample, trainSample, Dictionary, sc_algo, 400, scene_start);
%run the fast sparse coding
%[energy, avgTime, abnormalframe] = computeSRenergy(testSample, trainSample, Dictionary, param.L, sc_algo);

disp('click enter to draw the energy curve');
pause;

%% 
len = size(energy,1);
[X]=1:len;
figure;
plot(X, energy,'b', abnormalframe(:,1), abnormalframe(:,2), '.r');


%% graph show about the analysis result

% x = 1:1:400;
% y1 = xps(:,421);
% y2 = xps(:,525);
% figure(1)
% subplot(2,1,1), stem(x,y1,'g')
% %grid on;
% set(gca, 'YLim',[-3 3]);  % X轴的数据显示范围
% ylabel('稀疏系数');
% title('正常帧#421');
% subplot(2,1,2), stem(x,y2,'r');
% ylabel('稀疏系数');
% title('异常帧#525');
