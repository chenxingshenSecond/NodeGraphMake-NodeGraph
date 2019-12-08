clc 
% test
addpath(genpath(cd))
[V, Vt, Vn, F] = objread('smpl_openHhip.obj');

VertexLen = length(V); 

sampleList = [];
visitedFlag = zeros(VertexLen,1);
VisitList = 1 : VertexLen;


while ~isempty(VisitList) 
    
    i = VisitList(1);
    sampleList = [sampleList, i];
        
    Len = length(VisitList);
    
    dist = sum( (repmat( V(i,:) , Len, 1) - V(VisitList,:)).^2 , 2);
    
    % visitedId = find(dist < 0.003);
    visitedId = find(dist < 0.002);
    
    visitedId = VisitList(visitedId);
    
    visitedFlag(visitedId) = 1 ; 
    
    VisitList = find(visitedFlag==0);

end

csvwrite('nodeId.csv', sampleList);

sampleV = V(sampleList, :);
writeOBJ_Net('sampleV.obj', sampleV, []);
