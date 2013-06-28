% GenSimData: Generates simulation data for phase diagrams.

d = 200;
nArr = logspace(log10(d), log10(20000), 40);
kArr = 1:40;
numTrials = 100;
GenDataKNPlane('Lasso','USE','Uniform',d,nArr,kArr,numTrials);
GenDataKNPlane('Lasso','USE','Gaussian',d,nArr,kArr,numTrials);
GenDataKNPlane('Lasso','USE','Signs',d,nArr,kArr,numTrials);
GenDataKNPlane('Lasso','RSE','Uniform',d,nArr,kArr,numTrials);
GenDataKNPlane('Lasso','RSE','Gaussian',d,nArr,kArr,numTrials);
GenDataKNPlane('Lasso','RSE','Signs',d,nArr,kArr,numTrials);
GenDataKNPFP('USE','Uniform',d,nArr,kArr,numTrials);
GenDataKNPFP('USE','Gaussian',d,nArr,kArr,numTrials);
GenDataKNPFP('USE','Signs',d,nArr,kArr,numTrials);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = 1000;
dArr = linspace(100, 1000, 40);
numTrials = 100;
kArr = 2:2:100;
GenDataKDPlane('Lasso','USE','Uniform',n,dArr,kArr,numTrials);
GenDataKDPlane('Lasso','RSE','Uniform',n,dArr,kArr,numTrials);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = 1024;
dArr = linspace(100, 1000, 40);
numTrials = 100;
rhoArr = linspace(0.05,1,40);
GenDataRhoDPlane('RST','Uniform',n,rhoArr,dArr,numTrials);
GenDataRhoDPlane('RST','Gaussian',n,rhoArr,dArr,numTrials);
GenDataRhoDPlane('RST','Signs',n,rhoArr,dArr,numTrials);
GenDataRhoDPlane('Hadamard','Uniform',n,rhoArr,dArr,numTrials);
GenDataRhoDPlane('Hadamard','Gaussian',n,rhoArr,dArr,numTrials);
GenDataRhoDPlane('Hadamard','Signs',n,rhoArr,dArr,numTrials);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

n = 1000;
dArr = linspace(100, 1000, 40);
numTrials = 100;
rhoArr = linspace(0.05,1,40);
GenDataRhoDPlaneAll('USE','Uniform',n,rhoArr,dArr,numTrials);
GenDataRhoDPlaneAll('USE','Gaussian',n,rhoArr,dArr,numTrials);
GenDataRhoDPlaneAll('USE','Signs',n,rhoArr,dArr,numTrials);
GenDataRhoDPlaneAll('URP','Uniform',n,rhoArr,dArr,numTrials);
GenDataRhoDPlaneAll('URP','Gaussian',n,rhoArr,dArr,numTrials);
GenDataRhoDPlaneAll('URP','Signs',n,rhoArr,dArr,numTrials);


