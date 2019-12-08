function [ Jacobian , Loss ] =  JacobianDataFunc(canonical_xyz , KnnIndex, DepthInput , Twist )
DataLen   = length( KnnIndex ) ; 
ParamLen  = length( Twist ) ; 

Jacobian  = zeros(DataLen*3,ParamLen); 
Loss      = zeros(DataLen*3,1); 

for i = 1 : length( KnnIndex ) 
    pairInd = KnnIndex(i) - 1; 
    Trans = twist2Transform(Twist(pairInd*6+1:pairInd*6+6)) ; 
    WarpedVertex =  Trans * [canonical_xyz(pairInd+1,:),1]'; 
    InputVertex  =  DepthInput(i,:); %
    Jacobian(i*3-2:i*3 , pairInd*6+1:pairInd*6+6) = skew_matrix_ex( WarpedVertex ); %
    Loss(i*3-2:i*3,1)  = WarpedVertex - InputVertex'; %
end