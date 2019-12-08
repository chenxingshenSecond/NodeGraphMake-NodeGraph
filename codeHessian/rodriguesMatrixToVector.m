function rotationVector = rodriguesMatrixToVector(rotationMatrix)
% rodriguesMatrixToVector Convert a 3D rotation matrix into a rotation
% vector.
%
% rotationVector = rodriguesMatrixToVector(rotationMatrix) computes a 
% rotation vector (axis-angle representation) corresponding to a 3D 
% rotation matrix using the Rodrigues formula.
%
% rotationMatrix is a 3x3 3D rotation matrix.
%
% rotationVector is a 3-element rotation vector corresponding to the 
% rotationMatrix. The vector represents the axis of rotation in 3D, and its 
% magnitude is the rotation angle in radians.
%
% See also vision.internal.calibration.rodriguesVectorToMatrix

% References:
% [1] R. Hartley, A. Zisserman, "Multiple View Geometry in Computer
%     Vision," Cambridge University Press, 2003.
% 
% [2] E. Trucco, A. Verri. "Introductory Techniques for 3-D Computer
%     Vision," Prentice Hall, 1998.

% Copyright 2012 MathWorks, Inc.

% get the rotation matrix that is the closest approximation to the input
[U, ~, V] = svd(rotationMatrix);
rotationMatrix = U * V';

t = trace(rotationMatrix);
% t is the sum of the eigenvalues of the rotationMatrix.
% The eigenvalues are 1, cos(theta) + i sin(theta), cos(theta) - i sin(theta)
% t = 1 + 2 cos(theta), -1 <= t <= 3

theta = real(acos((t - 1) / 2));

r = [rotationMatrix(3,2) - rotationMatrix(2,3); ...
     rotationMatrix(1,3) - rotationMatrix(3,1); ...
     rotationMatrix(2,1) - rotationMatrix(1,2)];

threshold = 1e-4; 
if sin(theta) >= threshold
    % theta is not close to 0 or pi
    rotationVector = theta / (2 * sin(theta)) * r;
elseif t-1 > 0
    % theta is close to 0
    rotationVector = (.5 - (t - 3) / 12) * r;
else
    % theta is close to pi
    rotationVector = ...
        computeRotationVectorForAnglesCloseToPi(rotationMatrix, theta);
end

function rotationVector = ...
    computeRotationVectorForAnglesCloseToPi(rotationMatrix, theta)
% r = theta * v / |v|, where (w, v) is a unit quaternion.
% This formulation is derived by going from rotation matrix to unit
% quaternion to axis-angle

% choose the largest diagonal element to avoid a square root of a negative
% number
[~, a] = max(diag(rotationMatrix));
a = a(1);
b = mod(a, 3) + 1;
c = mod(a+1, 3) + 1;

% compute the axis vector
s = sqrt(rotationMatrix(a, a) - rotationMatrix(b, b) - rotationMatrix(c, c) + 1);
v = zeros(3, 1);
v(a) = s / 2;
v(b) = (rotationMatrix(b, a) + rotationMatrix(a, b)) / (2 * s);
v(c) = (rotationMatrix(c, a) + rotationMatrix(a, c)) / (2 * s);

rotationVector = theta * v / norm(v);
