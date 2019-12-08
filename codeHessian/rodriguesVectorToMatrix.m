function rotationMatrix = rodriguesVectorToMatrix(rotationVector)
% rodriguesVectorToMatrix Convert a 3D rotation vector into a rotation
% matrix.
%
% rotationMatrix = rodriguesVectorToMatrix(rotationVector) reconstructs a 
% 3D rotationMatrix from a rotationVector (axis-angle representation) using
% the Rodrigues formula.
%
% rotationVector is a 3-element vector representing the axis of rotation in
% 3D. The magnitude of the vector is the rotation angle in radians.
%
% rotationMatrix is a 3x3 3D rotation matrix corresponding to rotationVector. 
%
% See also vision.internal.calibration.rodriguesMatrixToVector

% References:
% [1] R. Hartley, A. Zisserman, "Multiple View Geometry in Computer
%     Vision," Cambridge University Press, 2003.
% 
% [2] E. Trucco, A. Verri. "Introductory Techniques for 3-D Computer
%     Vision," Prentice Hall, 1998.

% Copyright 2012 MathWorks, Inc.

theta = norm(rotationVector);

if theta < eps
    rotationMatrix = eye(3);
    return;
end

n = rotationVector ./ theta;

A = [n(1)^2,    n(1)*n(2), n(1)*n(3);...
     n(2)*n(1), n(2)^2,    n(2)*n(3);...
     n(3)*n(1), n(3)*n(2), n(3)^2    ];
 
B = [  0,  -n(3),  n(2);...
     n(3),   0,   -n(1);...
    -n(2),  n(1),   0   ];

rotationMatrix = eye(3) * cos(theta) + (1 - cos(theta)) * A + sin(theta) * B;  