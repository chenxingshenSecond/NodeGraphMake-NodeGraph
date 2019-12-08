%
% clc ;
clear all ; close all; 
fid = fopen('Liver_Removed.obj');
iter1  = 0 ;  
iter2 = 0 ;  
%% 
while( ~feof(fid) )
    SS = fgets(fid) ; 
    if( SS(1)=='v' &&  SS(2)==' ')
        iter1 = iter1+1 ;
        C = textscan(SS,  'v %f %f %f' ) ;  % 可以分析这一行数据 保存在C这个cell中
        x(iter1) = C{1} ;
        y(iter1) = C{2} ;
        z(iter1) = C{3} ;
    elseif ( SS(1)=='f' &&  SS(2)==' ')
        iter2 = iter2 +1 ;
        C = textscan(SS,  'f %d/%d/%d %d/%d/%d %d/%d/%d' ) ;  % 可以分析这一行数据 保存在C这个cell中 
        tehedron (iter2 ,: ) = [ C{1} C{4} C{7}] ; 
    end
end

fclose(fid);  

%%
xyz = [x',y',z'];
line1 =[tehedron(:,1:2);tehedron(:,2:3)];
line2 = sort(line1,2);
line2 = unique(line2,'rows');

Hessian = zeros(length(xyz) * 6);

xyz = xyz * 3 ; 

for i = 1:length(line2)
    indexi = line2(i,1) - 1 ;
    indexj = line2(i,2) - 1 ;
    
    Matrixi = skew_matrix_ex( xyz(indexi+1,:) ) ;
    Matrixj = skew_matrix_ex( xyz(indexj+1,:) ) ;
    
    Hessian(indexi*6+1:indexi*6+6,indexi*6+1:indexi*6+6) =...
    Hessian(indexi*6+1:indexi*6+6,indexi*6+1:indexi*6+6) + Matrixi'*Matrixi  ;
    
    Hessian(indexj*6+1:indexj*6+6,indexi*6+1:indexi*6+6) =...
    Hessian(indexj*6+1:indexj*6+6,indexi*6+1:indexi*6+6) + Matrixj'*Matrixi  ;

    Hessian(indexi*6+1:indexi*6+6,indexj*6+1:indexj*6+6) =...
    Hessian(indexi*6+1:indexi*6+6,indexj*6+1:indexj*6+6) + Matrixi'*Matrixj  ;
    
    Hessian(indexj*6+1:indexj*6+6,indexj*6+1:indexj*6+6) =...
    Hessian(indexj*6+1:indexj*6+6,indexj*6+1:indexj*6+6) + Matrixj'*Matrixj  ;
end

sum (sum(abs(Hessian-Hessian')))

cond(Hessian)

Hessian = Hessian + eye(size(Hessian))*10;
cond(Hessian)

figure ; imshow(Hessian/max(Hessian(:))*100);
% tehedron 
