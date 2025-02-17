function plotBone()
% plotBone - Plots the bone as a cuboid.
%
%   The bone is defined with a top face at z = 0 and a bottom face at z = -30.

% Define bone vertices
boneVerts = [ 0   0    0;    % v1: top front left
              50   0    0;    % v2: top front right
              50  50    0;    % v3: top back right
               0  50    0;    % v4: top back left
               0   0  -30;    % v5: bottom front left
              50   0  -30;    % v6: bottom front right
              50  50  -30;    % v7: bottom back right
               0  50  -30];   % v8: bottom back left

% Define faces (each row is a face defined by 4 vertices)
boneFaces = [1 2 3 4;   % Top face
             5 6 7 8;   % Bottom face
             1 2 6 5;   % Front face
             2 3 7 6;   % Right face
             3 4 8 7;   % Back face
             4 1 5 8];  % Left face

patch('Vertices', boneVerts, 'Faces', boneFaces, ...
      'FaceColor', [0.8 0.8 0.8], 'FaceAlpha', 0.5, 'EdgeColor', 'k', ...
      'DisplayName', 'Bone');
end
