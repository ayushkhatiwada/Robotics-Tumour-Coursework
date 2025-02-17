function [center, dims] = plotTumourBoundingBox(VerticesUnique)
% plotTumourBoundingBox - Computes and plots the bounding box of the tumour.
%
% Syntax: [center, dims] = plotTumourBoundingBox(VerticesUnique)
%
% Inputs:
%   VerticesUnique - Unique tumour surface points.
%
% Outputs:
%   center - [x_center, y_center, z_center] of the bounding box.
%   dims   - [tumourWidth, tumourLength, tumourHeight] dimensions.

% Compute min and max along each axis
x_min = min(VerticesUnique(:,1)); 
x_max = max(VerticesUnique(:,1));
y_min = min(VerticesUnique(:,2)); 
y_max = max(VerticesUnique(:,2));
z_min = min(VerticesUnique(:,3)); 
z_max = max(VerticesUnique(:,3));

% Calculate the center of the bounding box
x_center = (x_min + x_max) / 2;
y_center = (y_min + y_max) / 2;
z_center = (z_min + z_max) / 2;
center = [x_center, y_center, z_center];

% Calculate tumour dimensions
tumourWidth  = x_max - x_min;
tumourLength = y_max - y_min;
tumourHeight = z_max - z_min;
dims = [tumourWidth, tumourLength, tumourHeight];

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

% Define edges connecting the vertices
edges = [...
    1 2; 2 3; 3 4; 4 1;   % Bottom face edges
    5 6; 6 7; 7 8; 8 5;   % Top face edges
    1 5; 2 6; 3 7; 4 8];  % Vertical edges

hold on;

% Create a dummy plot for the legend entry
plot3(nan, nan, nan, 'k-', 'LineWidth', 2, 'DisplayName', 'Bounding Box');

% Plot all bounding box edges with 'HandleVisibility' set to 'off'
for i = 1:size(edges,1)
    plot3([boxVertices(edges(i,1),1), boxVertices(edges(i,2),1)], ...
          [boxVertices(edges(i,1),2), boxVertices(edges(i,2),2)], ...
          [boxVertices(edges(i,1),3), boxVertices(edges(i,2),3)], ...
          'k-', 'LineWidth', 2, 'HandleVisibility', 'off');
end

hold off;
end
