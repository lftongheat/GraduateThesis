%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算时空MRF的输入数据Evidence和Potential%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load FeaturesPattern.mat;%load data

%%parameter%%
spaceLen=10;
tau=0.7;
kv=0.65;
%%%%%end%%%%%

[height,width] = size(FeaturesPattern);
%c--number of mixtuer components samplenum-- number of samples
[c,framenum] = size(FeaturesPattern{1,1});
dataLen = framenum-10+1;
evidences = cell(dataLen,1);
potentials = cell(dataLen,1);

nodeNum = height*width;
factorNum = (width-1) * height + width * (height-1);

nodeDescriptors = cell(nodeNum,1);  %节点描述符
nodePosteriors = cell(nodeNum,1);   %节点的后验概率
nodeEvidence = cell(nodeNum,1);     %节点置信度
factorPotential = cell(factorNum,1);%因子势能
[linkage] = createLinkage2(width, height);%factorNum*2 维
freHist = cell(nodeNum,1);%the frequency histogram H=sum(pi) 
coHist = cell(factorNum,1);% the co-occurence histogram for neiboring node i and j H=sum(pi*pj)  
mahalHist = cell(nodeNum,1);%the Mahalanobis histogram

for i=1:nodeNum
    freHist{i} = zeros(1,c);
end
for i=1:nodeNum
    mahalHist{i} = zeros(1,c);
end
for i=1:factorNum
    coHist{i} = zeros(c,c);
end


for z=1:framenum
    for y=1:height
        for x=1:width
            MoFA = MoFAs{y,x};
            descriptor = Descriptors{y,x}(z,:);%activity descriptor
            nodeIndex = (y-1)*width + (x-1) + 1;

            nodeDescriptors{nodeIndex} = descriptor;
            nodePosteriors{nodeIndex} = FeaturesPattern{y,x}(:,z);

            sumf = 0; sums = 0;
            COVARANCE = cov(Descriptors{y,x});
            for k=1:c
                freHist{nodeIndex}(1,k) = freHist{nodeIndex}(1,k) + nodePosteriors{nodeIndex}(k,1);%accumulator                    
                mahalHist{nodeIndex}(1,k) = mahalHist{nodeIndex}(1,k) + ((descriptor'-MoFA.M(:,k))'/COVARANCE)*(descriptor'-MoFA.M(:,k));%计算ti和组件c的马氏距离
            end
            %normalization
            freHistNorm = norm(freHist{nodeIndex});
            mahalHistNorm = norm(mahalHist{nodeIndex});
            for k=1:c
                sumf = sumf + (freHist{nodeIndex}(1,k)/freHistNorm)*nodePosteriors{nodeIndex}(k,1);
                sums = sums + (mahalHist{nodeIndex}(1,k)/mahalHistNorm)*nodePosteriors{nodeIndex}(k,1);
            end
            nf1 = TransitionK(sumf,kv);
            nf0 = 1 - nf1;
            ns0 = TransitionK(sums,kv);
            ns1 = 1 - ns0;
            if ns0 > 0.5
                ne0 = (1-tau)*nf0 + tau*ns0;
                ne1 = (1-tau)*nf1 + tau*ns1;
            else
                ne0 = tau*nf0 + (1-tau)*ns0;
                ne1 = tau*nf1 + (1-tau)*ns1;
            end            
            nodeEvidence{nodeIndex} = [ne0,ne1];
        end
    end

    %计算初始因子势能
    for k=1:factorNum
        nodeIndex1 = linkage(k,1) + 1;
        nodeIndex2 = linkage(k,2) + 1;

        sum = 0;
        for i=1:c
            for j=1:c
                %需标准化
                coHist{k}(i,j) = coHist{k}(i,j) + ...
                    nodePosteriors{nodeIndex1}(i,1)*nodePosteriors{nodeIndex2}(j,1);%计算直方图coHist
            end
        end
        %normalization
        coHistNorm = norm(coHist{nodeIndex});
        for i=1:c
            for j=1:c
                sum = sum + (coHist{k}(i,j)/coHistNorm)*nodePosteriors{nodeIndex1}(i,1)*nodePosteriors{nodeIndex2}(j,1);
            end
        end
        
        pf11 = TransitionK(sum,kv);
        pfother = 1 - pf11;
        t1 = nodeDescriptors{nodeIndex1};
        t2 = nodeDescriptors{nodeIndex2};
        ps00 = dot(t1,t2)/norm(t1)/norm(t2); ps11 = ps00; %xi=xj
        ps01 = 0; ps10 = 0;%xi!=xj
        alpha = 0.5;
        p00 = pfother + alpha*ps00;
        p11 = pf11 + alpha*ps11;
        p01 = pfother + alpha*ps01;
        p10 = p01;
        factorPotential{k} = [p00,p01;p10,p11];
    end
    
%     if framenum == 10 %根据前面计算的置信度和势能初始化mrf的参数 
%         evidences{framenum-10+1} = nodeEvidence;
%     elseif framenum > 10 %对于每个新加入的帧更新mppca和mrf 
%         evidences{framenum-10+1} = nodeEvidence;
%     end
    if z >= 10
        evidences{z-9} = nodeEvidence;
        potentials{z-9} = factorPotential;
    end
end

save EPdata_65.mat evidences potentials;