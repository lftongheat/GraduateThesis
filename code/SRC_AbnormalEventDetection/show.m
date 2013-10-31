function varargout = show(varargin)
% SHOW MATLAB code for show.fig
%      SHOW, by itself, creates a new SHOW or raises the existing
%      singleton*.
%
%      H = SHOW returns the handle to a new SHOW or the handle to
%      the existing singleton*.
%
%      SHOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SHOW.M with the given input arguments.
%
%      SHOW('Property','Value',...) creates a new SHOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before show_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to show_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help show

% Last Modified by GUIDE v2.5 20-Oct-2013 21:03:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @show_OpeningFcn, ...
                   'gui_OutputFcn',  @show_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before show is made visible.
function show_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to show (see VARARGIN)

% Choose default command line output for show
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes show wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(gcf,'numbertitle','off','name','视频异常检测');


% --- Outputs from this function are returned to the command line.
function varargout = show_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbuttonRun.
function pushbuttonRun_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.text2,'string', num2str(0));
drawnow;
global fast;
global scene;
if isempty(fast);
    fast = 0;
end
if isempty(scene);
    scene = 1;
end
disp(['fast:', num2str(fast)]);
disp(['scene:', num2str(scene)]);
%main
addpath(genpath('tools/'));

%% Load training and testing data
% dataset
% UNM: scene1
disp('load data');
switch scene  
  case 1
    load data/HOFFeatures_umn_scene1_0.8.mat;
  case 2
    load data/HOFFeatures_umn_scene2_0.8.mat;
  case 3
    load data/HOFFeatures_umn_scene3_0.8.mat;
  otherwise
end 

disp('Normalization');
% Normalization: normalize all samples with zero mean and unit variance
HOFFeaturesAvg = mean(HOFFeatures,1);
HOFFeatures = HOFFeatures-ones(size(HOFFeatures,1),1)*HOFFeaturesAvg;
HOFFeaturesNorm = sqrt( sum(HOFFeatures.^2,1) );
HOFFeatures = HOFFeatures./ (ones(size(HOFFeatures,1),1)*HOFFeaturesNorm);

train_num = 400;
switch scene  
  case 1
    scene_start = 1;
    scene_end = 1449;
  case 2
    scene_start = 1455;
    scene_end = 5594;
    train_num = 310;
  case 3
    scene_start = 5600;
    scene_end = 7738;
  otherwise
end 

%
trainSample = HOFFeatures(:,scene_start:scene_start+train_num-1);     %320*400
testSample = HOFFeatures(:,scene_start:scene_end);   %320*

%% Learning dictionary from the training samples

% Parameters for dictionary learning
%redundencyFactor = 2;                           % The number of the atoms = data dimension x redundencyFactor 
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
fprintf('Solving sparse coding...\n');

if fast == 0
%run the common sparse coding
[energy, avgTime, abnormalframe] = computeSRenergy0(testSample, trainSample, Dictionary, sc_algo, train_num, scene_start);
else
%run the fast sparse coding
[energy, avgTime, abnormalframe] = computeSRenergy(testSample, trainSample, Dictionary, param.L, sc_algo,train_num, scene_start);
end

set(handles.text2,'string', num2str(avgTime));
drawnow;

disp('click enter to draw the energy curve');
pause;

len = size(energy,1);
[X]=1+scene_start-1:len+scene_start-1;
for i=1:size(abnormalframe(:,1))
    abnormalframe(i,1) = abnormalframe(i,1) + scene_start-1;
end

figure;
plot(X, energy,'b', abnormalframe(:,1), abnormalframe(:,2), '.r');
title('稀疏表示代价曲线', 'FontSize', 20);
xlabel('帧', 'FontSize', 18);
ylabel('稀疏表示代价', 'FontSize', 18);
set(gca,'FontSize',16);

% --- Executes on button press in radiobuttonFast.
function radiobuttonFast_Callback(hObject, eventdata, handles)
% hObject    handle to radiobuttonFast (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(handles.radiobuttonFast,'value',1);
% Hint: get(hObject,'Value') returns toggle state of radiobuttonFast
global fast;
if get(hObject, 'value')
    fast = 1;
else
    fast = 0;
end
disp(['fast:',num2str(fast)]);

% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuScene.
function popupmenuScene_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuScene (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global scene
scene = 1;
% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuScene contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuScene
switch get(handles.popupmenuScene,'Value')   
  case 1
    scene = 1;
  case 2
    scene = 2;
  case 3
    scene = 3;
  otherwise
end 
disp(['scene:',num2str(scene)]);

% --- Executes during object creation, after setting all properties.
function popupmenuScene_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuScene (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
