function [linkage] = createLinkage(m_nWidth, m_nHeight, m_nLength)
%compute the linkage of spatio-temporal mrf

factorNum = (width-1) * height * spaceLen + ...
            width * (height-1) * spaceLen + ...
            width * height * (spaceLen-1);
linkage = zero(factorNum, 2);

nNodesInPlane = m_nWidth * m_nHeight;
nFactorsInPlane = (m_nWidth - 1) * m_nHeight + ...
                      m_nWidth * ( m_nHeight - 1) + ...
                      m_nWidth * m_nHeight;

for l = 0:m_nLength
    factorIndexOffset = l * nFactorsInPlane;
    nodeIndexOffset = l * nNodesInPlane;
    %create linkage in the horizontal direction
    for h = 0:m_nHeight
        for w = 0:m_nWidth-1
            factorIndex = w + (2*m_nWidth-1)*h + factorIndexOffset;
            nodeIndex1 = w + m_nWidth*h + nodeIndexOffset;
            nodeIndex2 = nodeIndex1 + 1;
            linkage(factorIndex,1) = nodeIndex1;
            linkage(factorIndex,2) = nodeIndex2;
        end
    end
    %create linkage in the vertical direction
    for h = 0:m_nHeight-1
        for w =0:m_nWidth 
            factorIndex = w + (2*m_nWidth-1)*h + m_nWidth-1 + factorIndexOffset;
            nodeIndex1 = w + m_nWidth*h + nodeIndexOffset;
            nodeIndex2 = w + m_nWidth*(h+1) + nodeIndexOffset;
            linkage(factorIndex,1) = nodeIndex1;
            linkage(factorIndex,2) = nodeIndex2;
        end
    end
    if l < m_nLength - 1
        %create linkage in the length direction (i.e. temporal direction)
        factorIndexInLengthAxis = factorIndexOffset + (m_nWidth - 1) * m_nHeight + ...
                                    m_nWidth * ( m_nHeight - 1);
        for h =0:m_nHeight
            for w = 0:m_nWidth
                nodeIndex1 = w + m_nWidth*h + nodeIndexOffset;
                nodeIndex2 = nodeIndex1 + nNodesInPlane;
                linkage(factorIndexInLengthAxis,1) = nodeIndex1;
                linkage(factorIndexInLengthAxis,2) = nodeIndex2;
                factorIndexInLengthAxis = factorIndexInLengthAxis + 1;
            end
        end
    end
end

end%function