function [trainMatrixReduced, releventPosition] = reduceMatrix(testVector, trainMatrix)
% ---------------------------------------------------
% Fast Sparse Coding: reduceMatrix 
% Functionality: 
%       Select relevent columns (i.e., the ones with at least one overlapped support) 
%       in the train matrix and discard the rest      
% Dimension: K  --- number of atoms in the dictionary
%            Nd --- number of training samples
%            Nr --- number of relevent columns
%
%                           Dimension          Description
% input:  testVector           K x 1        --- the testing sample
%         trainMatrix          K x Nd       --- the training samples
% output: trainMatrixReduced   K x Nr       --- the sparse coefficient matrix of Y
%         releventPosition    Nr x 1        --- index indicating the
%                                               relevent columns
% ---------------------------------------------------

[K, Nd]=size(trainMatrix);

support = find(testVector);
numSupport = size(support,1);
supportMatch = zeros(1,size(trainMatrix,2));

for i=1:numSupport
    posNonzeroCoeff=support(i);
    matchedColumns=find(trainMatrix(posNonzeroCoeff,:));
    supportMatch(matchedColumns)=supportMatch(matchedColumns)+1;
end

releventPosition=(supportMatch>0);

trainMatrixReduced=trainMatrix(:,releventPosition);

end
