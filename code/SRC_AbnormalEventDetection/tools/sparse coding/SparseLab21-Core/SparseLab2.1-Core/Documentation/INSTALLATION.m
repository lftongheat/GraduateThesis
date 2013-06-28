% INSTALLATION -- Installation of SparseLab
% 
% 	Unix Instructions:  
% 
% 1. Binary download the archive to the directory you want SparseLab to reside 
% 2. Uncompress the archive:  
%    unzip SparseLab090.zip 
% 3. Decide where you want the SparseLab directory to reside. It will have
%    a number of subdirectories and occupy at least 2 MB disk space. 
% 4. After you unzip the file for your machine, you should have the
%    following directory structure:
%
%    SparseLab100 
%    SparseLab100/Code Packages
%    SparseLab100/Datasets
%    SparseLab100/Demos
%    SparseLab100/Documentation 
%    SparseLab100/Examples
%    SparseLab100/Examples/DeconvolutionmRNA
%    SparseLab100/Examples/TimeFrequency
%    SparseLab100/Examples/NMRSpectroscropy
%    SparseLab100/Examples/CompressedSensing
%    SparseLab100/Examples/ErrorCorrectingCodes
%    SparseLab100/Examples/NonNegativeFourier
%    SparseLab100/Papers
%    SparseLab100/Papers/ExtCS
%    SparseLab100/Papers/LEBP
%    SparseLab100/Papers/Deconvolution
%    SparseLab100/Papers/TimeSeries
%    SparseLab100/Papers/Polytopes
%    SparseLab100/Solvers
%    SparseLab100/Solvers/IST
%    SparseLab100/Solvers/PDCO
%    SparseLab100/Solvers/LARS
%    SparseLab100/Solvers/Simplex
%    SparseLab100/Solvers/OMP
%    SparseLab100/Solvers/FDR
%    SparseLab100/Solvers/IRWLS
%    SparseLab100/Solvers/MP
%    SparseLab100/Solvers/Stepwise
%    SparseLab100/Utilities
%    SparseLab100/Workouts
%
% 5. Edit the file SparsePath.m, put the lines 
%    if strcmp(Friend,'<YourMachineType>'),
%        SPARSELABPATH = '<AbsolutePathNameforSparseLabMainDirectory>' ;
%        PATHNAMESEPARATOR = '<YourMachine*sPathSeparator>';
%    end
%    in the appropriate place (this will be evident). Here the value of variable Friend 
%    has been defined by the Matlab command 
%    computer; 
%    Also, SPARSEPATH names the place where SparseLab will reside. For an individual user 
%    without root privileges, a good choice is 
%    ~<USERLOGIN>/matlab/SparseLab
%    where <USERLOGIN> is the user's account name. For a system manager with root privileges, 
%    a good choice is    
%    <MatlabToolBoxPath>/SparseLab                         
%    where <MatlabToolBoxPath> is the name of the directory containing all the Matlab toolboxes.
%
% 6. Copy all the SparseLab files from the place you put the original SparseLab archive 
%    (for example /tmp) to their final destination as named in the variable SPARSELABPATH, 
%    for example in your home directory  
%    ~user/matlab/SparseLab. 
% 7. Launch Matlab.  In Matlab, set the current path to
%        matlabroot/toolbox/SparseLab100
%    Alternatively, copy the file SparsePath.m from
%    <MatlabToolBoxPath>/SparseLab100
%    to
%    <MatlabToolBoxPath>/local 
% 8. Try running a script, to see if it will run. If it does not, recheck all the above steps. 
% 
%
% Note:
%
% 1. If you want Matlab to automatically load SparseLab upon start-up, copy the file 
%    SparsePath.m from the SparseLab100 folder to the folder <MatlabToolBoxPath>/local. 
%    If you already have a startup.m file in the directory matlab/toolbox/local, 
%    add to it the line 
%    SparsePath;
%    otherwise, rename the file SparsePath.m as startup.m. 
% 2. Upon successful installation, remove the zip file to save space. 
%
%
% Trouble-Shooting UNIX Installation
%
%    Compare the output of  
%       ls -r SparseLab 
%    with  
%       Documentation/WLFiles 
%    to see if you have all the files. Compare the output of the Matlab command  
%       path  
%    with the list above to see if you have all the directories in your path.
%
%-----------------------------------------------------------------------------------------
% 
% 	Macintosh Instructions:
% 
%  To follow these instructions you will need:
%
% (1) A Macintosh running MacOS 7.5 or later 
% (2) A program such as Stuffit Expander which can un-zip a .zip file. 
% (3) Matlab 5.X or 6.X for Macintosh 
% (4) In certain special circumstances, you may need to have the MPW C compiler to 
%    compile Mex files.
%
% Steps:
%
% 1. Binary Download the file 
%    SparseLab100.zip
%    to your Macintosh. You will need about 2MB of disk space. 
% 2. Extract the archive to the Toolbox folder of your Matlab folder.
%    After you extract the file,  you should have the following subdirectory structure:
%
%    SparseLab100 
%    SparseLab100:Code Packages
%    SparseLab100:Datasets
%    SparseLab100:Demos
%    SparseLab100:Documentation 
%    SparseLab100:Examples
%    SparseLab100:Examples:DeconvolutionmRNA
%    SparseLab100:Examples:TimeFrequency
%    SparseLab100:Examples:NMRSpectroscropy
%    SparseLab100:Examples:CompressedSensing
%    SparseLab100:Examples:ErrorCorrectingCodes
%    SparseLab100:Examples:NonNegativeFourier
%    SparseLab100:Papers
%    SparseLab100:Papers:ExtCS
%    SparseLab100:Papers:LEBP
%    SparseLab100:Papers:Deconvolution
%    SparseLab100:Papers:TimeSeries
%    SparseLab100:Papers:Polytopes
%    SparseLab100:Solvers
%    SparseLab100:Solvers:IST
%    SparseLab100:Solvers:PDCO
%    SparseLab100:Solvers:LARS
%    SparseLab100:Solvers:Simplex
%    SparseLab100:Solvers:OMP
%    SparseLab100:Solvers:FDR
%    SparseLab100:Solvers:IRWLS
%    SparseLab100:Solvers:MP
%    SparseLab100:Solvers:Stepwise
%    SparseLab100:Utilities
%    SparseLab100:Workouts
%
%
% 3. In Matlab, either set the current path to
%    matlabroot:toolbox:SparseLab100
%    or copy the file SparsePath.m from
%    matlabroot:toolbox:SparseLab100
%    to
%    matlabroot:toolbox:local 
% 4. Run SparsePath at the command prompt to start BeamLab 200. 
%    You will see a "Welcome to SparseLab" message. 
%
%
% Note: 
%
% 1. If you want Matlab to automatically load SparseLab upon start-up, copy the file 
%    SparsePath.m from the folder SparseLab100 to the folder Matlab:Toolbox:Local. 
%    Using Find File from the Mac Finder, determine if you have any files named startup.m 
%    (besides the one contained in Matlab:Toolbox:SparseLab) in the hierarchy rooted at Matlab.
%    If you don't, skip to step 3 below. 
% 2. If you do have more than one startup.m file, copy and append the contents of the SparsePath.m 
%    in Matlab:Toolbox:SparseLab100 to the startup.m. The setup is complete. 
% 3. Edit SparsePath.m if your Matlab directory has a different pathname reference than the 
%    one supplied at the top of this file.  
% 4. Upon successful installation, remove the zip file to save space. 
%
%-----------------------------------------------------------------------------------------
%
% 	Windows Instructions:  
%
% To follow these instructions you will need: 
%
% (1) An Intel platform box running Win 95/98/2000/XP or NT. 
% (2) A program such as WinZip which can un-zip a .zip file. 
% (3) Matlab 5.X, 6.X, 7.x for Windows. 
% (4) In certain special circumstances, you may need to have the MFC C compiler to compile Mex files. 
%
% Steps:
%
% 1. Download (in binary mode) the file  
%    SparseLab100.zip 
%    to your PC by using the appropriate link from the SparseLab home page. 
%    Extract the .zip file into the folder
%       /matlab/toolbox/ 
%    Remark: If your Matlab root directory is named differently than 
%       /matlab
%    then use its correct name (for example /MATLABR12) instead of the /matlab convention 
%    we use every time the Matlab root directory is referred. 
%    After you unzip you should have the following subdirectory structure: 
%
%    SparseLab100 
%    SparseLab100/Code Packages
%    SparseLab100/Datasets
%    SparseLab100/Demos
%    SparseLab100/Documentation 
%    SparseLab100/Examples
%    SparseLab100/Examples/DeconvolutionmRNA
%    SparseLab100/Examples/TimeFrequency
%    SparseLab100/Examples/NMRSpectroscropy
%    SparseLab100/Examples/CompressedSensing
%    SparseLab100/Examples/ErrorCorrectingCodes
%    SparseLab100/Examples/NonNegativeFourier
%    SparseLab100/Papers
%    SparseLab100/Papers/ExtCS
%    SparseLab100/Papers/LEBP
%    SparseLab100/Papers/Deconvolution
%    SparseLab100/Papers/TimeSeries
%    SparseLab100/Papers/Polytopes
%    SparseLab100/Solvers
%    SparseLab100/Solvers/IST
%    SparseLab100/Solvers/PDCO
%    SparseLab100/Solvers/LARS
%    SparseLab100/Solvers/Simplex
%    SparseLab100/Solvers/OMP
%    SparseLab100/Solvers/FDR
%    SparseLab100/Solvers/IRWLS
%    SparseLab100/Solvers/MP
%    SparseLab100/Solvers/Stepwise
%    SparseLab100/Utilities
%    SparseLab100/Workouts
%
% 3. In Matlab, set the current path to
%       matlab/toolbox/SparseLab100
%    Alternatively, copy the file SparsePath.m from
%       matlab/toolbox/SparseLab100
%    to
%       matlab/toolbox/local 
% 4. Run 
%        SparsePath 
%    at the command prompt to start SparseLab 200.  
%    Matlab should return a "Welcome to SparseLab" message. 
% 5. Try running a script to see if it will run. If it does not, recheck all the above steps. 
%
%
%    Note:
%
% 1. If you want Matlab to automatically load SparseLab upon start-up, copy the file 
%        SparsePath.m 
%    from the folder  
%        SparseLab100 
%    to the folder  
%        matlab/toolbox/local
%    If you already have a startup.m file in the directory matlab/toolbox/local, add to it the line 
%        SparsePath; 
%    otherwise, rename SparsePath.m as startup.m. 
% 2. Upon successful installation, remove the zip file to save space. 
%
%
% Trouble-Shooting Windows
%
%    It may be that your version of Matlab has different folders structure than what is 
%    assumed here and the folder 
%        matlab/toolbox/local 
%    doesn't exist. In this case look for the folder of Matlab that contains the startup and 
%    path definition files and use it instead. In older versions of Matlab it used to be the folder 
%        matlab/bin  
%    
%    If you prefer to place SparseLab in a different folder of Matlab than the one we suggest, 
%    it's ok to do so. In this case you will need to edit the file SparsePath.m and chage the line 
%        addpath(genpath([matlabroot, PATHNAMESEPARATOR, 'toolbox', PATHNAMESEPARATOR, dr(k).name])); 
%    Instead of 
%        'toolbox'
%    you will have your chosen folder.
%    
%    While in Matlab, check that the 
%        path 
%    command returns a list that looks like the one under item 2 above.
%    
%    If you are unable to get the .dll files to work at all, don't worry -- 
%    SparseLab will still work, but more slowly. 
%
    help('INSTALLATION');

%
% Copyright (c) 2006. Victoria Stodden and David Donoho
% 

%
% Part of SparseLab Version:100
% Created Tuesday March 28, 2006
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail sparselab@stanford.edu
%
