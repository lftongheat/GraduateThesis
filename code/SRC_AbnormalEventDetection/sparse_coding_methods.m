function [xp] = sparse_coding_methods(xInit, A, y, sc_algo)
% ---------------------------------------------------
% Fast Sparse Representation with Prototypes: sparse_coding_methods 
% Functionality: 
%       Solve sparse solution of the linear system y=Ax using the specificed
%       sparse coding method.
% Dimension: m --- number of measurement
%            Nd--- number of training samples
%
%                   Dimension          Description
% input:  xInit      Nd x 1        --- the initial solution of y=Ax
%         A          m x Nd        --- the training sample
%         y          m x 1         --- the testing sample
%         sc_algo                  --- the sparse coding algorithm
%          e.g., l1magic, SparseLab, fast_sc, SL0, YALL1
%
% Reference: Jia-Bin Huang and Ming-Hsuan Yang, "Fast Sparse Representation with Prototypes.", the 23th IEEE Conference
%            on Computer Vision and Pattern Recognition (CVPR 10'), San Francisco, CA, USA, June 2010.
% Contact: For any questions, email me by jbhuang@ieee.org
% ---------------------------------------------------

    [m Nd]=size(A);
    
    if( strcmp(sc_algo, 'l1magic'))
        epsilon = 0.05;
        xp = l1qc_logbarrier(xInit, A, [], y, epsilon, 1e-3);
    elseif(strcmp(sc_algo, 'SparseLab'))
        maxIters=20;
        lambda = 0.05;
        xp = SolveBP(A, y, Nd, maxIters, lambda, 1e-3);
    elseif(strcmp(sc_algo, 'fast_sc'))
        
    elseif(strcmp(sc_algo, 'SL0'))
        
    elseif(strcmp(sc_algo, 'YALL1'))
        
    else
       error('A sparse coding algorithm must be specified.');
    end
end