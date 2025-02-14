% Load tumour data
load X.mat
load Y.mat
load Z.mat

%%%%%%%%%%%%%%%
% Plot Tumour %
%%%%%%%%%%%%%%%

% Compute convex hull of tumour
[k2, av2] = convhull(X,Y,Z, 'Simplify', true);
trisurf(k2,X,Y,Z,'FaceColor','cyan')

hold on
axis equal
xlim([0 50])
ylim([0 50])
zlim([-30 20])
xlabel('x')
ylabel('y')
zlabel('z')
title('Tumour Visualization with Bounding Box')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extract Unique Tumour Vertices   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Vertices = [X(k2(:,1)),Y(k2(:,1)),Z(k2(:,1))];
Vertices = [Vertices; X(k2(:,2)),Y(k2(:,2)),Z(k2(:,2))];
Vertices = [Vertices; X(k2(:,3)),Y(k2(:,3)),Z(k2(:,3))];
VerticesUnique = unique(Vertices,'rows');

% Plot unique tumour surface points
scatter3(VerticesUnique(:,1),VerticesUnique(:,2),VerticesUnique(:,3),'r')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Bounding Box for Cutting %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 1: Compute bounding box limits
x_min = min(VerticesUnique(:,1)); 
x_max = max(VerticesUnique(:,1));
y_min = min(VerticesUnique(:,2)); 
y_max = max(VerticesUnique(:,2));
z_min = min(VerticesUnique(:,3)); 
z_max = max(VerticesUnique(:,3));

% Step 2: Compute center of the bounding box
x_center = (x_min + x_max) / 2;
y_center = (y_min + y_max) / 2;
z_center = (z_min + z_max) / 2;

% Step 3: Compute bounding box dimensions
width  = x_max - x_min;
length = y_max - y_min;
height = z_max - z_min;

% Print computed values
fprintf('Bounding Box Center: (%.2f, %.2f, %.2f)\n', x_center, y_center, z_center);
fprintf('Bounding Box Dimensions (Width x Length x Height): %.2f x %.2f x %.2f\n', width, length, height);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Visualize Bounding Box around Tumour (Cutting Area) %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Define bounding box vertices
boxVertices = [
    x_min y_min z_min;  % Bottom-front-left
    x_max y_min z_min;  % Bottom-front-right
    x_max y_max z_min;  % Bottom-back-right
    x_min y_max z_min;  % Bottom-back-left
    x_min y_min z_max;  % Top-front-left
    x_max y_min z_max;  % Top-front-right
    x_max y_max z_max;  % Top-back-right
    x_min y_max z_max]; % Top-back-left

% Define bounding box edges (pairs of vertices)
edges = [
    1 2; 2 3; 3 4; 4 1; % Bottom face
    5 6; 6 7; 7 8; 8 5; % Top face
    1 5; 2 6; 3 7; 4 8]; % Vertical edges

% Plot bounding box edges
for i = 1:size(edges,1)
    plot3([boxVertices(edges(i,1),1), boxVertices(edges(i,2),1)], ...
          [boxVertices(edges(i,1),2), boxVertices(edges(i,2),2)], ...
          [boxVertices(edges(i,1),3), boxVertices(edges(i,2),3)], ...
          'k-', 'LineWidth', 2);
end

legend('Tumour', 'Tumour Surface Points', 'Bounding Box')
hold off
