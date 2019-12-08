function  [mesh , Joints] = updateSmplModels(Theta,T_mean,kintree_table,J_regressor,weights)
%% 
Joints = J_regressor * T_mean ; 
%% 
rotes = Rodrigues2Rotation( Theta(1,:) ); 
trans = Theta(25,:) + Joints(1,:) ; %% + rotes * Joints(1,:); %% Joints(1,:); 
Joints_transform = zeros(4,4,24); 
externTransform  = zeros(4,4,24); 
Joints_transform(1:3,1:3,1) = rotes;
Joints_transform(1:3,4,1)   = trans' ;
Joints_transform(4,4,1)    = 1 ;
externTransform(1:3,1:3,1)  = eye(3);
externTransform(1:3,4,1)    = - Joints(1,:)' ;
externTransform(4,4,1)    = 1 ;
%% 
for i = 2 : 24 
    Father = kintree_table(1,i) + 1 ;  % 
    deltaTrans = Joints(i,:) - Joints(Father,:) ;
    spotTransform = [Rodrigues2Rotation( Theta(i,:)), deltaTrans' ; 0 0 0 1];
    externTransform(:,:,i)  = [eye(3),-Joints(i,:)'; 0 0 0 1]; 
    Joints_transform(:,:,i) = Joints_transform(:,:,Father) * spotTransform ;  
end
%% 
% Joints_transform_Final=
for i = 1 : 24
    Joints_transform(:,:,i) = Joints_transform(:,:,i) * externTransform(:,:,i);
end

%% 
smplNum = length(T_mean);
T_mean_ext = [T_mean,ones(smplNum,1)]'; 
mesh = zeros(4,smplNum); 

for i = 1:24
    weights_slice =  repmat(weights(:,i), 1 , 4);
    mesh = mesh + weights_slice' .* (Joints_transform(:,:,i) * T_mean_ext);
end
mesh = mesh(1:3,:)'; 
%% 
Joints = J_regressor * mesh ; 
end