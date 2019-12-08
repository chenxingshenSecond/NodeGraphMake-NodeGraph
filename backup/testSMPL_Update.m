
clc 
% test
addpath(genpath(cd))
% obj = readObj('smpl_np-norm.obj');
faces      = csvread('faces.csv'); 
T_mean      = csvread('v_template.csv'); 
weights     = csvread('weights.csv'); 
Beta_Model  = csvread('shapedirs.csv'); % shapedirs.csv 
J_regressor = csvread('J_regressor.csv'); % shapedirs.csv 
kintree_table = csvread('kintree_table.csv'); 
kintree_table(1) = 28; 
% 
Joints = J_regressor * T_mean ; 
%% 
Theta = zeros(25,3); 

[mesh1 , Joints1] = updateSmplModels(Theta,T_mean,kintree_table,J_regressor,weights); 

Theta = rand(25,3)* 0.001; 
Theta(1,:) = [1,0,0]; 
Theta(16,:) = [1,0,0]; 
Theta(18,:) = [0,1,0]; 
Theta(19,:) = [0,-1,0]; 
% Theta(20,:) = [0,-1,0]; 

[mesh2 , Joints2] = updateSmplModels(Theta,T_mean,kintree_table,J_regressor,weights); 


%%
figure('color',[1 1 1]); 
trisurf(faces+1,mesh1(:,1),mesh1(:,2),mesh1(:,3),'edgecolor','None');% plot3(mesh1(:,1),mesh1(:,2),mesh1(:,3),'r*');
hold on; 
trisurf(faces+1,mesh2(:,1),mesh2(:,2),mesh2(:,3),'edgecolor','None');% plot3(mesh2(:,1),mesh2(:,2),mesh2(:,3),'bo');
axis equal ; axis vis3d ; daspect([1 1 1])
%%
figure('color',[1 1 1]); plot3(Joints1(:,1),Joints1(:,2),Joints1(:,3),'r*');
hold on; plot3(Joints2(:,1),Joints2(:,2),Joints2(:,3),'bo');
axis equal ; axis vis3d ; daspect([1 1 1]); %% 

%%
figure('color',[1 1 1]); 
trisurf(faces+1,mesh1(:,1),mesh1(:,2),mesh1(:,3),'edgecolor','None');
axis equal ; axis vis3d ; daspect([1 1 1]); %% 

% Theta(3:4)

% fid = fopen('smpl_normal.bin','wb'); 
% fwrite(fid,obj.vn ,'float'); 
% fclose(fid); 
% %
% 
% fid = fopen('smpl_normal.bin','rb'); 
% A = fread(fid,6890*3,'float'); % 
% sum(A - obj.vn(:))
