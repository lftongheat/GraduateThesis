%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算时空MRF的输入数据Evidence和Potential%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load FeaturesPattern.mat;%load data

[height,width] = size(FeaturesPattern);
%c--number of mixtuer components samplenum-- number of samples
[c,samplenum] = size(FeaturesPattern{1,1});
spaceLen = 10;
%the frequency histogram H=sum(pi)
%freHist = zero(c,1);
% the co-occurence histogram for neiboring node i and j H=sum(pi*pj)
%coHist 

nodeNum = height*width*spaceLen;
factorNum = (width-1) * height * spaceLen + ...
            width * (height-1) * spaceLen + ...
            width * height * (spaceLen-1);
nodesNumInPlane = height*width;  %一帧(平面）中的节点数 
factorsNumInPlane = (width - 1) * height + ...
		                  width * ( height - 1) + ...
						  width * height; %一帧(平面）中的因子数 
nodeEvidence = cell(nodeNum,1);     %节点置信度
nodePosterior = cell(nodeNum,1);    %节点的后验概率
factorPotential = cell(factorNum,1);%因子势能
[linkage] = createLinkage(width, height, spaceLen);%factorNum*2 维
t=0.85;%parameter

%问题1.在初始化10帧，当新的帧加入时原时空MRF节点的变化如何计算  对置信向量进行更改
%问题2.如何计算成对势能
%问题3.如何计算马氏距离
for z=1:spaceLen
    for y=1:height
        for x=1:width
            nodeIndex = (z-1)*nodesNumInPlane + (y-1)*width + (x-1);%how to compute
            nodePosterior{nodeIndex} = FeaturesPattern{y,x}(:,z);
            sum = 0;
            for k=1:c
               freHist = sum(FeaturesPattern{y,x}(k,1:z));
               sum = sum + freHist*FeaturesPattern{y,x}(k,z);
            end
            nf1 = TransitionK(sum);
            nf0 = 1 - nf1;
            ns0 = 0.6;%?????????
            if ns0 > 0.5
                ne0 = (1-t)*nf0 + t*ns0;
            else
                ne0 = t*nf0 + (1-t)*ns0;
            end    
            ne1 = 1 - ne0;           
            nodeEvidence{nodeIndex} = [ne0,ne1];
            
            %如何计算向量节点的coHist
        end
    end  
end

%计算因子势能
for k=1:factorNum
    nodeIndex1 = linkage(k,1);
    nodeIndex2 = linkage(k,2);
    
    %计算直方图coHist
    coHist = 1;
    sum = 0;
    for i=1:c
        for j=1:c
            sum = sum + ...
                coHist*nodePosterior{nodeIndex1}(i,1)*nodePosterior{nodeIndex2}(j,1);
        end
    end
    pf11 = TransitionK(sum);
    pfother = 1 - pf11;
    
    ps00 = dot(ti,tj)/norm(ti)/norm(tj); %xi=xj
    ps11 = ps00; ps01 = 0; ps10 = 0;
    alpha = 0.5;
    p00 = pfother + alpha*ps00;
    p11 = pf11 + alpha*ps11;
    p01 = pfother + alpha*ps01;
    p10 = p01;
    factorPotential{k} = [p00,p01;p10,p11];
end

% save testdata.mat nodeEvidence factorPotential;