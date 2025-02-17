function plotCuttingToolPath(VerticesUnique)
% plotCuttingToolPath - Plots the cutting tool path as extruded side walls.
%
% Syntax: plotCuttingToolPath(VerticesUnique)
%
% The function computes the 2D convex hull (in the x-y plane) of the tumour
% surface points, and then extrudes these points vertically between z_top (0)
% and the lowest z-value of the tumour to form side walls that represent the
% cutting tool path.

% Compute the 2D convex hull in the x-y plane.
k_xy = convhull(VerticesUnique(:,1), VerticesUnique(:,2));
x_hull = VerticesUnique(k_xy, 1);
y_hull = VerticesUnique(k_xy, 2);

% Define the top and bottom z-levels for the extrusion.
z_top    = 0;  
z_bottom = min(VerticesUnique(:,3));

% Create the top and bottom vertices for the extrusion.
topVertices    = [x_hull, y_hull, repmat(z_top, numel(x_hull), 1)];
bottomVertices = [x_hull, y_hull, repmat(z_bottom, numel(x_hull), 1)];

% Plot the side walls of the extruded cutting tool path.
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
end
