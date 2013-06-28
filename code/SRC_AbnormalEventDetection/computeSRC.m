function [X] = computeSRC(Y, A, D, L, sc_algo)
% ---------------------------------------------------
% Compute Sparse Representation Cost using Fast Sparse Representation with Prototypes
% Functionality: 
%       Find the approaximated sparse solution x of the linear system y=Ax
% Dimension: m  --- number of measurement
%            Nte--- number of testing samples
%            Ntr--- number of training samples
%
%                   Dimension          Description
% input:  Y          m x Nte       --- the testing sample
%         A          m x Ntr       --- the training sample
%         D          m x K         --- the learned dictionary
%         L                        --- the number of atoms in OMP
%         sc_algo                  --- the sparse coding algorithm
%                            e.g., l1magic, SparseLab, fast_sc, SL0, YALL1
% output: X          K x Nte       --- the sparse coefficient matrix of Y
%         accuracy                 --- accuracy of the classification task
%         avgTime                  --- average runtime for sparse coding
% 
% Reference: Jia-Bin Huang and Ming-Hsuan Yang, "Fast Sparse Representation with Prototypes.", the 23th IEEE Conference
%            on Computer Vision and Pattern Recognition (CVPR 10'), San Francisco, CA, USA, June 2010.
% Contact: For any questions, email me by jbhuang@ieee.org
% ---------------------------------------------------


Nte = size(Y, 2);
Ntr = size(A, 2);

X = zeros(Ntr, Nte);

% Compute the new representation of A as WA
WA = OMP(D, A, L);

% Compute the new representation of Y as WY
WY = OMP(D, Y, L);

% Compute the sparse representation X
Ainv = pinv(A);
for i = 1: Nte
    % Inital guess
    xInit = Ainv * Y(:,i);
    xp = zeros(Ntr,1);
    
    % new representation of the test sample y
    w_y = WY(:,i);
    
    % keep columns with a least one overlapped support and dicard the rest
    [WA_reduced, releventPosition] = reduceMatrix(w_y, WA);
    
    % sparse coding: solve a reduced linear system
    xpReduced = sparse_coding_methods(xInit(releventPosition), WA_reduced, w_y, sc_algo);

    xp(releventPosition)=xpReduced;
   
    X(:, i) = xp;
    
end

end