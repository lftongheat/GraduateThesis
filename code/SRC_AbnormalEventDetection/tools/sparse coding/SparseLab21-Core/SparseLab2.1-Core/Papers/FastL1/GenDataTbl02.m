% GenDataTblXX: Plots maximum iteration estimates for different ensembles

ComputeMaxIters('USE','Uniform',1000,.25)
ComputeMaxIters('USE','Gaussian',1000,.25)
ComputeMaxIters('USE','Signs',1000,.25)

ComputeMaxIters('URP','Uniform',1000,.25)
ComputeMaxIters('URP','Gaussian',1000,.25)
ComputeMaxIters('URP','Signs',1000,.25)

ComputeMaxIters('RST','Uniform',1024,.25)
ComputeMaxIters('RST','Gaussian',1024,.25)
ComputeMaxIters('RST','Signs',1024,.25)

ComputeMaxIters('Hadamard','Uniform',1024,.25)
ComputeMaxIters('Hadamard','Gaussian',1024,.25)
ComputeMaxIters('Hadamard','Signs',1024,.25)

