function [Hessian] = HessianRegFunc(canonical_xyz,line2,Twist)

Hessian = zeros(length(canonical_xyz) * 6);

for i = 1:length(line2)
    indexi = line2(i,1) - 1 ;
    indexj = line2(i,2) - 1 ;
    
	T1 = twist2Transform(Twist(indexi*6+1:indexi*6+6)); 
	T2 = twist2Transform(Twist(indexj*6+1:indexj*6+6)); 
	
	
    Matrixi =   skew_matrix_ex( T1 * [ canonical_xyz(indexj+1,:),1]' ) ;
    Matrixj = - skew_matrix_ex( T2 * [ canonical_xyz(indexj+1,:),1]' ) ;
    
    Hessian(indexi*6+1:indexi*6+6,indexi*6+1:indexi*6+6) =...
    Hessian(indexi*6+1:indexi*6+6,indexi*6+1:indexi*6+6) + Matrixi'*Matrixi  ;
    
    Hessian(indexj*6+1:indexj*6+6,indexi*6+1:indexi*6+6) =...
    Hessian(indexj*6+1:indexj*6+6,indexi*6+1:indexi*6+6) + Matrixj'*Matrixi  ;

    Hessian(indexi*6+1:indexi*6+6,indexj*6+1:indexj*6+6) =...
    Hessian(indexi*6+1:indexi*6+6,indexj*6+1:indexj*6+6) + Matrixi'*Matrixj  ;
    
    Hessian(indexj*6+1:indexj*6+6,indexj*6+1:indexj*6+6) =...
    Hessian(indexj*6+1:indexj*6+6,indexj*6+1:indexj*6+6) + Matrixj'*Matrixj  ;
	
	
    Matrixi = - skew_matrix_ex( T1 * [ canonical_xyz(indexi+1,:),1]' ) ;
    Matrixj =   skew_matrix_ex( T2 * [ canonical_xyz(indexi+1,:),1]' ) ;	
	
    Hessian(indexi*6+1:indexi*6+6,indexi*6+1:indexi*6+6) =...
    Hessian(indexi*6+1:indexi*6+6,indexi*6+1:indexi*6+6) + Matrixi'*Matrixi  ;
    
    Hessian(indexj*6+1:indexj*6+6,indexi*6+1:indexi*6+6) =...
    Hessian(indexj*6+1:indexj*6+6,indexi*6+1:indexi*6+6) + Matrixj'*Matrixi  ;

    Hessian(indexi*6+1:indexi*6+6,indexj*6+1:indexj*6+6) =...
    Hessian(indexi*6+1:indexi*6+6,indexj*6+1:indexj*6+6) + Matrixi'*Matrixj  ;
    
    Hessian(indexj*6+1:indexj*6+6,indexj*6+1:indexj*6+6) =...
    Hessian(indexj*6+1:indexj*6+6,indexj*6+1:indexj*6+6) + Matrixj'*Matrixj  ;
	
end
end