load X.mat
load Y.mat
load Z.mat

figure;
hold on;

%% Plot Bone as a Cuboid
% Define vertices for the cuboid representing the bone.
% Top face (bone surface) is at z = 0, bottom face is at z = -30.
boneVerts = [ 0   0    0;    % v1: top front left
             50   0    0;    % v2: top front right
             50  50    0;    % v3: top back right
              0  50    0;    % v4: top back left
              0   0  -30;    % v5: bottom front left
             50   0  -30;    % v6: bottom front right
             50  50  -30;    % v7: bottom back right
              0  50  -30];   % v8: bottom back left

% Define the six faces of the cuboid
boneFaces = [1 2 3 4;   % Top face (bone surface)
             5 6 7 8;   % Bottom face
             1 2 6 5;   % Front face
             2 3 7 6;   % Right face
             3 4 8 7;   % Back face
             4 1 5 8];  % Left face

% Plot the cuboid with a light grey color, semi-transparency, and visible edges
patch('Vertices', boneVerts, 'Faces', boneFaces, ...
      'FaceColor', [0.8 0.8 0.8], 'FaceAlpha', 0.5, 'EdgeColor', 'k');

%% Plot Tumour (Convex Hull)
% Compute convex hull for the tumour points
[k2, ~] = convhull(X, Y, Z, 'Simplify', true);
trisurf(k2, X, Y, Z, 'FaceColor', 'cyan', 'EdgeColor', 'k', 'FaceAlpha', 1);

%% Plot Unique Tumour Surface Points
% Extract and remove duplicate vertices from the convex hull
Vertices = [X(k2(:,1)), Y(k2(:,1)), Z(k2(:,1));
            X(k2(:,2)), Y(k2(:,2)), Z(k2(:,2));
            X(k2(:,3)), Y(k2(:,3)), Z(k2(:,3))];
VerticesUnique = unique(Vertices, 'rows');

% Plot these unique points as red markers
scatter3(VerticesUnique(:,1), VerticesUnique(:,2), VerticesUnique(:,3), ...
         'r', 'filled');

%% Compute Bounding Box for the Tumour
% Step 1: Compute limits of the tumour surface points
x_min = min(VerticesUnique(:,1)); 
x_max = max(VerticesUnique(:,1));
y_min = min(VerticesUnique(:,2)); 
y_max = max(VerticesUnique(:,2));
z_min = min(VerticesUnique(:,3)); 
z_max = max(VerticesUnique(:,3));

% Step 2: Compute the center (for informational purposes)
x_center = (x_min + x_max) / 2;
y_center = (y_min + y_max) / 2;
z_center = (z_min + z_max) / 2;

% Step 3: Compute dimensions of the bounding box
width  = x_max - x_min;
length = y_max - y_min;
height = z_max - z_min;

% Print computed values to the command window
fprintf('Bounding Box Center: (%.2f, %.2f, %.2f)\n', x_center, y_center, z_center);
fprintf('Bounding Box Dimensions (Width x Length x Height): %.2f x %.2f x %.2f\n', ...
        width, length, height);

%% Visualize Bounding Box around the Tumour
% Define the 8 vertices of the bounding box
boxVertices = [...
    x_min, y_min, z_min;  % Bottom-front-left
    x_max, y_min, z_min;  % Bottom-front-right
    x_max, y_max, z_min;  % Bottom-back-right
    x_min, y_max, z_min;  % Bottom-back-left
    x_min, y_min, z_max;  % Top-front-left
    x_max, y_min, z_max;  % Top-front-right
    x_max, y_max, z_max;  % Top-back-right
    x_min, y_max, z_max]; % Top-back-left

% Define edges of the bounding box (each row: start and end vertex indices)
edges = [...
    1 2; 2 3; 3 4; 4 1;   % Bottom face edges
    5 6; 6 7; 7 8; 8 5;   % Top face edges
    1 5; 2 6; 3 7; 4 8];  % Vertical edges

% Plot each edge of the bounding box
for i = 1:size(edges,1)
    plot3([boxVertices(edges(i,1),1), boxVertices(edges(i,2),1)], ...
          [boxVertices(edges(i,1),2), boxVertices(edges(i,2),2)], ...
          [boxVertices(edges(i,1),3), boxVertices(edges(i,2),3)], ...
          'k-', 'LineWidth', 2);
end

%% Final Plot Adjustments
axis equal;
xlim([0 50]);
ylim([0 50]);
zlim([-30 20]);
xlabel('x');
ylabel('y');
zlabel('z');
grid on;
view(3);
legend('Bone', 'Tumour', 'Tumour Surface Points', 'Bounding Box');
title('Tumour and Bone Visualization with Bounding Box');

hold off;
