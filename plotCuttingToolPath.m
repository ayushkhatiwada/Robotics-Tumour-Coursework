function plotCuttingToolPath(VerticesUnique, tolerance, colour)
% plotCuttingToolPath - Plots the cutting tool path as extruded side walls.
%
% Syntax: plotCuttingToolPath(VerticesUnique, tolerance, colour)
%
% Inputs:
%   VerticesUnique - Unique tumour surface points.
%   tolerance      - Outward offset distance from the tumour convex hull.
%   colour         - Colour for the cutting tool path (e.g., 'm', [1 0 1], etc.).
%
% The function computes the 2D convex hull (in the x-y plane) of the tumour
% surface points, applies an outward offset using the specified tolerance, and then
% extrudes these offset points vertically between z_top (0) and the lowest z-value
% of the tumour to form side walls that represent the cutting tool path.

% Compute the 2D convex hull in the x-y plane.
k_xy = convhull(VerticesUnique(:,1), VerticesUnique(:,2));
x_hull = VerticesUnique(k_xy, 1);
y_hull = VerticesUnique(k_xy, 2);

% Create a polyshape from the convex hull.
tumourPoly = polyshape(x_hull, y_hull);

% Expand the polygon by the specified tolerance.
offsetPoly = polybuffer(tumourPoly, tolerance);

% Extract the offset polygon vertices.
[x_hull_offset, y_hull_offset] = boundary(offsetPoly);

% Define the top and bottom z-levels for the extrusion.
z_top    = 0;  
z_bottom = min(VerticesUnique(:,3));

% Create the top and bottom vertices for the extrusion.
topVertices    = [x_hull_offset, y_hull_offset, repmat(z_top, numel(x_hull_offset), 1)];
bottomVertices = [x_hull_offset, y_hull_offset, repmat(z_bottom, numel(x_hull_offset), 1)];

% Plot the side walls of the extruded cutting tool path.
n = numel(x_hull_offset);
for i = 1:n
    j = mod(i, n) + 1;
    faceVerts = [topVertices(i,:); topVertices(j,:); bottomVertices(j,:); bottomVertices(i,:)];
    if i == 1
        patch(faceVerts(:,1), faceVerts(:,2), faceVerts(:,3), colour, ...
              'FaceAlpha', 0.3, 'EdgeColor', colour, 'DisplayName', 'Cutting Tool Path');
    else
        patch(faceVerts(:,1), faceVerts(:,2), faceVerts(:,3), colour, ...
              'FaceAlpha', 0.3, 'EdgeColor', colour, 'HandleVisibility','off');
    end
end
end
