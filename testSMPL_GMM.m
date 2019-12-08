clc 
clear all; 
close all; 
addpath(genpath(cd))
% obj = readObj('smpl_np-norm.obj');
means     = csvread('means.csv'); 
covars    = csvread('covars.csv'); 
theta = zeros(25,3); 
x = theta(2:24,:); 
x = x(:);
x = means(1,:)'; 

weights   = [0.07125439 0.29085364 0.17402614 0.07201802 0.05940199 0.14041086 0.01589702 0.17613794]; 
%%
covars_mat= zeros(69,69,8);
covars_inv= zeros(69,69,8);
for i=1:8 
    covars_mat(:,:,i) = covars(i*69-68:i*69,:);
    covars_inv(:,:,i) = inv(covars_mat(:,:,i));
end

weights_vec = zeros(8,1); 
loss_beforelog = zeros(8,1); 
for i=1:8
    weights_vec(i) = 1 / sqrt( det( ((2*pi)) * covars_mat(:,:,i)) ) * weights(i);
    loss_beforelog(i) = weights_vec(i) * exp(-(x-means(i,:)')'*covars_inv(:,:,i)*(x-means(i,:)')/2.0);
end
%%
losslog = -log10(sum(loss_beforelog));
losslog
weights_vec
%%%
faces      = csvread('faces.csv'); 
T_mean      = csvread('v_template.csv'); 
weights     = csvread('weights.csv'); 
Beta_Model  = csvread('shapedirs.csv'); % shapedirs.csv 
J_regressor = csvread('J_regressor.csv'); % shapedirs.csv 
kintree_table = csvread('kintree_table.csv'); 
kintree_table(1) = 28; 
%% 
figure('color',[1 1 1]);
for i = 1:8
    Theta = zeros(25,3);
    Theta = Theta';
    Theta(4:69+3)= means(i,:)' ;
    Theta(end-2:end)= [1;2;3];
    Theta = Theta';
    [mesh1 , Joints1] = updateSmplModels(Theta,T_mean,kintree_table,J_regressor,weights);
    
    %%
    subplot(2,4,i);
    trisurf(faces+1,mesh1(:,1),mesh1(:,2),mesh1(:,3),'edgecolor','None');
    axis equal ; axis vis3d ; daspect([1 1 1]); %%
    view([0 0 1]); title(num2str(i));
end