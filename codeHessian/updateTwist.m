function newTwist = updateTwist(delta_X, Twist)
newTwist = zeros(length(Twist),1); 
TwistLen = length(Twist); 
for i = 0:TwistLen/6-1
    rotationMatrix_Delta = rodriguesVectorToMatrix(delta_X(i*6+1:i*6+3));
    rotationMatrix_Old   = rodriguesVectorToMatrix(Twist(i*6+1:i*6+3));
    rotationMatrix       = rotationMatrix_Delta * rotationMatrix_Old ; 
    rot = rodriguesMatrixToVector(rotationMatrix) ; 
    newTwist(i*6+1:i*6+3) = rot ; 
    transOld = Twist(i*6+4:i*6+6) ;
    transNew = delta_X(i*6+4:i*6+6) ;
    trans = transNew + rotationMatrix_Delta * transOld ; 
    newTwist(i*6+4:i*6+6) = trans; 
end
end