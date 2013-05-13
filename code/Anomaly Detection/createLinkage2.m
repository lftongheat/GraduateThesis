function [ linkage ] = createLinkage2( m_nWidth, m_nHeight )
%CREATELINKAGE2 Summary of this function goes here
%   Detailed explanation goes here


factorNum = (m_nWidth-1)*m_nHeight + m_nWidth*(m_nHeight-1);
linkage = zeros(factorNum, 2);
%create linkage in the horizontal direction
for h = 0:m_nHeight-1
    for w = 0:m_nWidth-2
        factorIndex = w + (2*m_nWidth-1)*h;
        nodeIndex1 = w + m_nWidth*h;
        nodeIndex2 = nodeIndex1 + 1;
        linkage(factorIndex+1,1) = nodeIndex1;
        linkage(factorIndex+1,2) = nodeIndex2;
    end
end

%create linkage in the vertical direction
for h = 0:m_nHeight-2
    for w =0:m_nWidth-1 
        factorIndex = w + (2*m_nWidth-1)*h + m_nWidth-1;
        nodeIndex1 = w + m_nWidth*h;
        nodeIndex2 = w + m_nWidth*(h+1);
        linkage(factorIndex+1,1) = nodeIndex1;
        linkage(factorIndex+1,2) = nodeIndex2;
    end
end	

end

