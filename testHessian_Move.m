%
clear all ; close all;
addpath(genpath(cd));
[vertex , normal, texture , faces] = objread('cat-low.obj') ; %
%%
vertex = vertex / 200; 

VertexLen = length(vertex);
line1 = [ faces(:,1:2);faces(:,2:3) ];
line2 =  sort(line1,2);
line2 =  unique(line2,'rows');
Twist = zeros(VertexLen*6,1) ;
canonical_xyz = vertex;
%%
% KnnIndex = randperm(VertexLen);
% KnnIndex = KnnIndex(1:floor(VertexLen/5));
% KnnIndexLen = length(KnnIndex);
figure;
%DepthInput = canonical_xyz(KnnIndex,:) + randn(KnnIndexLen,3);
%DepthInput = vertex(KnnIndex,:) + ones(KnnIndexLen,3);
KnnIndex  = randperm(VertexLen);
KnnIndex    =  KnnIndex(1:floor(VertexLen/2.5));
KnnIndexLen = length(KnnIndex);

for i = 1 : 100
    Rotation   = rodriguesVectorToMatrix([0.01,0.4,0.01]' * i + randn(3,1)*0.1);
    DepthInput = canonical_xyz (KnnIndex,:) * Rotation + i/200 + randn(KnnIndexLen,3) * 0.01; 
    plot3( DepthInput(:,1), DepthInput(:,2) , DepthInput(:,3) , 'rs'); axis equal ; axis vis3d ; hold on; % 
    %% vertex(KnnIndex,:) = DepthInput ;
    for j = 1 : 10 
        plot3( DepthInput(:,1), DepthInput(:,2) , DepthInput(:,3) , 'rs'); axis equal ; axis vis3d ; hold on; %
        [ JacobianData , LossData ] =  JacobianDataFunc (canonical_xyz , KnnIndex , DepthInput , Twist);
        [ JacobianReg  , LossReg  ] =  JacobianRegcgwFunc  (canonical_xyz , line2    , Twist);
        
        JacobianReg =  JacobianReg * 2 ;
        LossReg     =  LossReg * 2  ;
        
        HessianReg  = JacobianReg'*JacobianReg; 
                        
        %max(diag(HessianReg))
        %min(diag(HessianReg))
        %figure; plot(diag(HessianReg))
        
        
        HessianData = JacobianData'*JacobianData;
        Hessian     = HessianReg + HessianData;
        
        Residual    = JacobianData' *  LossData + JacobianReg' * LossReg; %
        %         tic;
        %         delta_X     = - Hessian \ Residual; %
        %         toc
        preConditionFlag = 2 ; 
        % tic;
        delta_X = - pcgFunc( Hessian, Residual , preConditionFlag) ; 
        %toc
        % disp(['max(delta_X)  = ', num2str(max(abs(delta_X)))]) ; %
        Twist  = updateTwist( delta_X, Twist );
        vertex = updateVertex(canonical_xyz, Twist);
        % disp(['max(Twist)  = ', num2str(max(abs(Twist)))]) ; %
        disp(['rank(HessianReg) = ', num2str(rank(HessianReg))]) ; %
        %%disp(['cond(Hessian) = ', num2str(cond(Hessian))]) ; %
        plot3( vertex(:,1), vertex(:,2) , vertex(:,3) , 'b*'); axis equal ; axis vis3d ; hold off; % 
        drawnow ;
    end
    %clf; 
end
%%
disp(['sum(sum(abs(Hessian-Hessian))) = ', num2str( sum (sum(abs(Hessian-Hessian'))) )]); %
disp(['cond(Hessian) = ', num2str(cond(Hessian))]) ; %
disp(['max(delta_X)  = ', num2str(max(abs(delta_X)))]) ; %
disp(['rank(Hessian) = ', num2str(rank(Hessian))]) ; %
%%
figure; plot3( vertex(:,1), vertex(:,2),vertex(:,3),'*'); axis equal ; axis vis3d ; hold on; %
plot3( DepthInput(:,1),DepthInput(:,2),DepthInput(:,3),'rs'); %
reshape( delta_X , 6 , length(delta_X)/6  ); %
reshape( Twist   , 6 , length(Twist)/6    ); %  
