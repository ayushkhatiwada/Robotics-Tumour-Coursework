function plotTumourOutline(VerticesUnique, tolerance, colour, lineStyle)
% plotTumourOutline - Plots an outline around the tumour in the z-axis.
%
% Syntax: plotTumourOutline(VerticesUnique, tolerance, colour, lineStyle)
%
% Inputs:
%   VerticesUnique - Unique tumour surface points.
%   tolerance      - Outward offset distance from the tumour convex hull.
%   colour         - Colour for the outline (e.g., 'm', [1 0 1], etc.).
%   lineStyle      - Line style (e.g., '-', '--', ':', '-.', etc.).
%
% This function computes the 2D convex hull (in the x-y plane) of the tumour
% surface points, applies an outward offset using the specified tolerance,
% and then plots only the top outline without any downward extrusion.

hold on;  % Ensure the plot is not overwritten

% Compute the 2D convex hull in the x-y plane.
k_xy = convhull(VerticesUnique(:,1), VerticesUnique(:,2));
x_hull = VerticesUnique(k_xy, 1);
y_hull = VerticesUnique(k_xy, 2);

% Create a polyshape from the convex hull.
tumourPoly = polyshape(x_hull, y_hull);

% Expand the polygon by the specified tolerance.
if tolerance > 0
    offsetPoly = polybuffer(tumourPoly, tolerance);
else
    offsetPoly = tumourPoly; % Use the original shape if no tolerance
end

% Extract the offset polygon vertices.
[x_hull_offset, y_hull_offset] = boundary(offsetPoly);

% Define the z-level for the outline.
z_top = 0;

% Ensure outline forms a closed loop
x_hull_offset = [x_hull_offset; x_hull_offset(1)];
y_hull_offset = [y_hull_offset; y_hull_offset(1)];

% Plot the outline at the top surface level with the specified line style.
plot3(x_hull_offset, y_hull_offset, repmat(z_top, size(x_hull_offset)), ...
      'Color', colour, 'LineWidth', 2, 'LineStyle', lineStyle, ...
      'DisplayName', 'Tumour Outline');

hold off; % Keep hold state as it was before
end
