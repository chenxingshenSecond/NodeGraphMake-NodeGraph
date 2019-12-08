% function [ vertex , normal, texture , faces ] = objread( filename )
function [ vertex , normal, texture , faces ] = objread( filename )
% function [ vertex , normal, texture , faces ] = objread( filename )
fid = fopen(filename);
iter1 = 0 ;  iter2 = 0 ;  iter3 = 0 ;  iter4 =0;
nx =[]; ny=[]; nz=[]; tx=[];ty=[]; 
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
        if(~isempty(C{9}))
            tehedron (iter2 ,: ) = [ C{1} C{4} C{7}] ;
        else
            C = textscan(SS,  'f %d//%d %d//%d %d//%d' ) ;  % 可以分析这一行数据 保存在C这个cell中 
            if(~isempty(C{6}))
                tehedron (iter2 ,: ) = [ C{1} C{3} C{5}] ;
            else
                C = textscan(SS,  'f %d %d %d' ) ;  % 可以分析这一行数据 保存在C这个cell中 
                tehedron (iter2 ,: ) = [ C{1} C{2} C{3}] ;
            end
        end
    end
    if( SS(1)=='v' &&  SS(2)=='n')
        iter3 = iter3 + 1; 
        C = textscan(SS,  'vn %f %f %f' ) ;  % 可以分析这一行数据 保存在C这个cell中
        nx(iter3) = C{1} ;
        ny(iter3) = C{2} ;
        nz(iter3) = C{3} ;
    end
    if( SS(1)=='v' &&  SS(2)=='t')
        iter4 = iter4+1 ;
        C = textscan(SS,  'vt %f %f' ) ;  % 可以分析这一行数据 保存在C这个cell中
        tx(iter4) = C{1} ;
        ty(iter4) = C{2} ;
    end
end

fclose(fid);  

%%
vertex  = [ x',y',z' ];
normal  = [nx',ny',nz'];
faces = tehedron;
texture = [tx',ty'];
end

