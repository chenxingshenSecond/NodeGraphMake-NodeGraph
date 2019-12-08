function Transform = twist2Transform(vec_n)
Rotation  = rodriguesVectorToMatrix(vec_n(1:3)); 
Transform = [Rotation,[vec_n(4);vec_n(5);vec_n(6)]];
end