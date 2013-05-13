function [linkage] = createLinkage(m_nWidth, m_nHeight, m_nLength)
%compute the linkage of spatio-temporal mrf

factorNum = (m_nWidth-1) * m_nHeight * m_nLength + ...
            m_nWidth * (m_nHeight-1) * m_nLength + ...
            m_nWidth * m_nHeight * (m_nLength-1);
linkage = zeros(factorNum, 2);

nNodesInPlane = m_nWidth * m_nHeight;
nFactorsInPlane = (m_nWidth - 1) * m_nHeight + ...
                      m_nWidth * ( m_nHeight - 1) + ...
                      m_nWidth * m_nHeight;

for l = 0:m_nLength-1
    factorIndexOffset = l * nFactorsInPlane;
    nodeIndexOffset = l * nNodesInPlane;
    %create linkage in the horizontal direction
    for h = 0:m_nHeight-1
        for w = 0:m_nWidth-2
            factorIndex = w + (2*m_nWidth-1)*h + factorIndexOffset;
            nodeIndex1 = w + m_nWidth*h + nodeIndexOffset;
            nodeIndex2 = nodeIndex1 + 1;
            linkage(factorIndex+1,1) = nodeIndex1;
            linkage(factorIndex+1,2) = nodeIndex2;
        end
    end
    %create linkage in the vertical direction
    for h = 0:m_nHeight-2
        for w =0:m_nWidth-1 
            factorIndex = w + (2*m_nWidth-1)*h + m_nWidth-1 + factorIndexOffset;
            nodeIndex1 = w + m_nWidth*h + nodeIndexOffset;
            nodeIndex2 = w + m_nWidth*(h+1) + nodeIndexOffset;
            linkage(factorIndex+1,1) = nodeIndex1;
            linkage(factorIndex+1,2) = nodeIndex2;
        end
    end
    if l < m_nLength - 1
        %create linkage in the length direction (i.e. temporal direction)
        factorIndexInLengthAxis = factorIndexOffset + (m_nWidth - 1) * m_nHeight + ...
                                    m_nWidth * ( m_nHeight - 1);
        for h =0:m_nHeight-1
            for w = 0:m_nWidth-1
                nodeIndex1 = w + m_nWidth*h + nodeIndexOffset;
                nodeIndex2 = nodeIndex1 + nNodesInPlane;
                linkage(factorIndexInLengthAxis+1,1) = nodeIndex1;
                linkage(factorIndexInLengthAxis+1,2) = nodeIndex2;
                factorIndexInLengthAxis = factorIndexInLengthAxis + 1;
            end
        end
    end
end

end%function