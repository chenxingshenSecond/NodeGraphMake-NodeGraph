function vertex = updateVertex(canonical_vertex, Twist)
vertex = zeros(length(canonical_vertex),3); 
TwistLen = length(Twist); 
for i = 0:TwistLen/6-1
    rotationMatrix_Old = rodriguesVectorToMatrix(Twist(i*6+1:i*6+3));
    transOld           = Twist(i*6+4:i*6+6) ;
    new = rotationMatrix_Old * [canonical_vertex(i+1,:)]' + transOld;

    vertex(i+1,:) = new';
end

end