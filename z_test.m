load('X.mat'); % Contains variable X
load('Y.mat'); % Contains variable Y
load('Z.mat'); % Contains variable Z

figure;
hold on;

%% Plot Bone as a Cuboid
% Bone: top face (bone surface) is at z = 0, bottom face is at z = -30.
boneVerts = [ 0   0    0;    % v1: top front left
             50   0    0;    % v2: top front right
             50  50    0;    % v3: top back right
              0  50    0;    % v4: top back left
              0   0  -30;    % v5: bottom front left
             50   0  -30;    % v6: bottom front right
             50  50  -30;    % v7: bottom back right
              0  50  -30];   % v8: bottom back left

boneFaces = [1 2 3 4;   % Top face
             5 6 7 8;   % Bottom face
             1 2 6 5;   % Front face
             2 3 7 6;   % Right face
             3 4 8 7;   % Back face
             4 1 5 8];  % Left face

patch('Vertices', boneVerts, 'Faces', boneFaces, ...
      'FaceColor', [0.8 0.8 0.8], 'FaceAlpha', 0.5, 'EdgeColor', 'k', ...
      'DisplayName', 'Bone');

%% Plot Tumour (Convex Hull)
[k2, ~] = convhull(X, Y, Z, 'Simplify', true);
trisurf(k2, X, Y, Z, 'FaceColor', 'cyan', 'EdgeColor', 'k', 'FaceAlpha', 1, ...
        'DisplayName', 'Tumour');

%% Plot Unique Tumour Surface Points
% Extract all vertices used by the convex hull and remove duplicates.
Vertices = [X(k2(:,1)), Y(k2(:,1)), Z(k2(:,1));
            X(k2(:,2)), Y(k2(:,2)), Z(k2(:,2));
            X(k2(:,3)), Y(k2(:,3)), Z(k2(:,3))];
VerticesUnique = unique(Vertices, 'rows');
scatter3(VerticesUnique(:,1), VerticesUnique(:,2), VerticesUnique(:,3), ...
         40, 'r', 'filled', 'DisplayName', 'Tumour Surface Points');

%% Compute Bounding Box for the Tumour
x_min = min(VerticesUnique(:,1)); 
x_max = max(VerticesUnique(:,1));
y_min = min(VerticesUnique(:,2)); 
y_max = max(VerticesUnique(:,2));
z_min = min(VerticesUnique(:,3)); 
z_max = max(VerticesUnique(:,3));

% Compute the centre of the bounding box
x_center = (x_min + x_max) / 2;
y_center = (y_min + y_max) / 2;
z_center = (z_min + z_max) / 2;

% Compute tumour dimensions (renamed to avoid shadowing built-ins)
tumourWidth  = x_max - x_min;
tumourLength = y_max - y_min;
tumourHeight = z_max - z_min;

fprintf('Bounding Box Center: (%.2f, %.2f, %.2f)\n', x_center, y_center, z_center);
fprintf('Bounding Box Dimensions (Width x Length x Height): %.2f x %.2f x %.2f\n', ...
        tumourWidth, tumourLength, tumourHeight);

% Define bounding box vertices
boxVertices = [...
    x_min, y_min, z_min;  % Bottom-front-left
    x_max, y_min, z_min;  % Bottom-front-right
    x_max, y_max, z_min;  % Bottom-back-right
    x_min, y_max, z_min;  % Bottom-back-left
    x_min, y_min, z_max;  % Top-front-left
    x_max, y_min, z_max;  % Top-front-right
    x_max, y_max, z_max;  % Top-back-right
    x_min, y_max, z_max]; % Top-back-left

edges = [...
    1 2; 2 3; 3 4; 4 1;   % Bottom face edges
    5 6; 6 7; 7 8; 8 5;   % Top face edges
    1 5; 2 6; 3 7; 4 8];  % Vertical edges

% Plot bounding box edges. Label only the first edge.
for i = 1:size(edges,1)
    if i == 1
        plot3([boxVertices(edges(i,1),1), boxVertices(edges(i,2),1)], ...
              [boxVertices(edges(i,1),2), boxVertices(edges(i,2),2)], ...
              [boxVertices(edges(i,1),3), boxVertices(edges(i,2),3)], ...
              'k-', 'LineWidth', 2, 'DisplayName', 'Bounding Box');
    else
        plot3([boxVertices(edges(i,1),1), boxVertices(edges(i,2),1)], ...
              [boxVertices(edges(i,1),2), boxVertices(edges(i,2),2)], ...
              [boxVertices(edges(i,1),3), boxVertices(edges(i,2),3)], ...
              'k-', 'LineWidth', 2, 'HandleVisibility', 'off');
    end
end

%% Create and Plot Cutting Tool Prism (Side Faces Only, Extended to Tumour's Lowest z)
% Compute the 2D convex hull (x-y plane) of the tumour's surface points.
k_xy = convhull(VerticesUnique(:,1), VerticesUnique(:,2));
x_hull = VerticesUnique(k_xy, 1);
y_hull = VerticesUnique(k_xy, 2);

% Define the top z-level (where the cutting tool starts) and the bottom z-level 
% as the lowest z value of the tumour.
z_top    = 0;  
z_bottom = min(VerticesUnique(:,3));

% Build the top and bottom vertices of the prism.
topVertices    = [x_hull, y_hull, repmat(z_top, numel(x_hull), 1)];
bottomVertices = [x_hull, y_hull, repmat(z_bottom, numel(x_hull), 1)];

% Plot only the side faces of the prism.
n = numel(x_hull);
for i = 1:n
    j = mod(i, n) + 1;
    faceVerts = [topVertices(i,:); topVertices(j,:); bottomVertices(j,:); bottomVertices(i,:)];
    if i == 1
        patch(faceVerts(:,1), faceVerts(:,2), faceVerts(:,3), 'm', ...
              'FaceAlpha', 0.3, 'EdgeColor', 'm', 'DisplayName', 'Cutting Tool Path');
    else
        patch(faceVerts(:,1), faceVerts(:,2), faceVerts(:,3), 'm', ...
              'FaceAlpha', 0.3, 'EdgeColor', 'm', 'HandleVisibility','off');
    end
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
legend('Location','best');
title('Tumour and Bone Visualization with Bounding Box and Cutting Tool Prism (Side Faces Only)');

hold off;
