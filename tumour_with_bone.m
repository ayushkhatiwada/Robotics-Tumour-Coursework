load X.mat
load Y.mat
load Z.mat

figure
hold on

%% Plot Bone as a Cuboid
% Define vertices for the cuboid representing the bone.
% Top face (bone surface) is at z = 0,
% Bottom face is at z = -30.
boneVerts = [ 0   0    0;    % v1: top front left
             50   0    0;    % v2: top front right
             50  50    0;    % v3: top back right
              0  50    0;    % v4: top back left
              0   0  -30;    % v5: bottom front left
             50   0  -30;    % v6: bottom front right
             50  50  -30;    % v7: bottom back right
              0  50  -30];   % v8: bottom back left

% Define the six faces of the cuboid (each row gives indices to vertices)
boneFaces = [1 2 3 4;   % Top face (bone surface)
             5 6 7 8;   % Bottom face
             1 2 6 5;   % Front face
             2 3 7 6;   % Right face
             3 4 8 7;   % Back face
             4 1 5 8];  % Left face

% Plot the cuboid with a light grey color, semi-transparency, and visible edges
patch('Vertices', boneVerts, 'Faces', boneFaces, ...
      'FaceColor', [0.8 0.8 0.8], 'FaceAlpha', 0.5, 'EdgeColor', 'k');

%% Plot Tumour
% Compute the convex hull for the tumour points.
[k2, av2] = convhull(X, Y, Z, 'Simplify', true);
% Plot the tumour with visible edges (default color: black) to show the mesh lines.
trisurf(k2, X, Y, Z, 'FaceColor', 'cyan', 'EdgeColor', 'k', 'FaceAlpha', 1);

%% Plot Unique Tumour Vertices
% Extract all vertices used by the convex hull and remove duplicates.
Vertices = [X(k2(:,1)), Y(k2(:,1)), Z(k2(:,1));
            X(k2(:,2)), Y(k2(:,2)), Z(k2(:,2));
            X(k2(:,3)), Y(k2(:,3)), Z(k2(:,3))];
VerticesUnique = unique(Vertices, 'rows');

% Plot the unique tumour vertices as red markers.
scatter3(VerticesUnique(:,1), VerticesUnique(:,2), VerticesUnique(:,3), 'r', 'filled');

%% Final Plot Adjustments
axis equal
xlim([0 50])
ylim([0 50])
zlim([-30 20])
xlabel('x')
ylabel('y')
zlabel('z')
grid on   % Show grid lines in the 3D axes
view(3)   % Set a 3D view
