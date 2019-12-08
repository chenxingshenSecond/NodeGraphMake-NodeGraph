%{
%     罗德里格斯变换
%     输入：1*3的罗德里格斯向量
%     输出3*3矩阵  为旋转矩阵
%    
%   参考文献:
%   新浪微博：http://blog.sina.com.cn/s/blog_5fb3f125010100hp.html
%   CSDN空间：http://blog.csdn.net/bugrunner/article/details/7359100
%   维基百科：http://en.wikipedia.org/wiki/Rodrigues'_rotation_formula  
%}

function Rotation_matrix=Rodrigues2Rotation(rod)
theta=norm(rod);
if( theta>1e-8)
    r=rod'/theta;
else
    r=rod';
end

rx=[0 -r(3)  r(2);r(3) 0 -r(1); -r(2) r(1) 0];
Rotation_matrix=eye(3,3)+sin(theta)*rx+(1-cos(theta))*rx*rx;
% one_r=r./theta;
% Rotation_matrix=cos(theta)*eye(3,3)+(1-cos(theta))*one_r*one_r'+sin(theta)*[0 -one_r(3)  one_r(2);one_r(3) 0 -one_r(1); -one_r(2) one_r(1) 0];
% 下面这种办法也可以：
%{
rx=[0 -r(3)  r(2);r(3) 0 -r(1); -r(2) r(1) 0];
R2=eye(3,3)+sin(theta)/theta*rx+(1-cos(theta))/theta^2*rx*rx;
(R-R')/2-sin(theta)*[0   -one_r(3)  one_r(2);one_r(3)  0  -one_r(1);-one_r(2) one_r(1)   0 ]
 Rx=(R-R')/2;
%}