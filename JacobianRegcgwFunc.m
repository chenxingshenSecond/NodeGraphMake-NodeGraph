function [Jacobian,Loss] = JacobianRegcgwFunc(canonical_xyz,line2,Twist)

Jacobian = zeros( length(line2) * 2 * 3 , length(canonical_xyz) * 6);
Loss= zeros( length(line2) * 2 * 3 , 1);

for i = 1:length(line2)
    indexi = line2(i,1) - 1 ;
    indexj = line2(i,2) - 1 ;
    
    T1 = twist2Transform(Twist(indexi*6+1:indexi*6+6));
    T2 = twist2Transform(Twist(indexj*6+1:indexj*6+6));
    
    % Matrixi =   skew_matrix_ex( T1 * [ canonical_xyz(indexj+1,:),1]' ) ;
    % Matrixj = - skew_matrix_ex( T2 * [ canonical_xyz(indexj+1,:),1]' ) ;
    Matrixi =   skew_matrix_ex( T1 * [1,0.3,1,1]' ) ;
    Matrixj = - skew_matrix_ex( T2 * [1,0.3,1,1]' ) ;
    
    Jacobian( i*6-5:i*6-3 , indexi*6+1:indexi*6+6 ) = Matrixi ;
    Jacobian( i*6-5:i*6-3 , indexj*6+1:indexj*6+6 ) = Matrixj ;
    
%     Matrixi = - skew_matrix_ex( T1 * [ canonical_xyz(indexi+1,:),1]' ) ;
%     Matrixj =   skew_matrix_ex( T2 * [ canonical_xyz(indexi+1,:),1]' ) ;
%     
    Matrixi =   skew_matrix_ex( T1 * [1,1,1,1]' ) ;
    Matrixj = - skew_matrix_ex( T2 * [1,1,1,1]' ) ; 
    Jacobian( i*6-2:i*6-0 , indexi*6+1:indexi*6+6 ) = Matrixi ;
    Jacobian( i*6-2:i*6-0 , indexj*6+1:indexj*6+6 ) = Matrixj ;
    
    Loss(i*6-5 : i*6-3) = T1*[1,0.3,1,1]' - T2*[1,0.3,1,1]' ;
    Loss(i*6-2 : i*6-0) = T2*[1,1,1,1]' - T1*[1,1,1,1]';
end
end