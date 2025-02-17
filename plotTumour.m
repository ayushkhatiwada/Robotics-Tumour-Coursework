function VerticesUnique = plotTumour(X, Y, Z)
% plotTumour - Plots the tumour as a convex hull and its unique surface points.
%
% Syntax: VerticesUnique = plotTumour(X, Y, Z)
%
% Inputs:
%   X, Y, Z - Vectors of tumour surface points.
%
% Output:
%   VerticesUnique - Unique vertices used in the tumour convex hull.

% Compute the convex hull indices with simplification.
[k2, ~] = convhull(X, Y, Z, 'Simplify', true);

% Plot the convex hull surface.
trisurf(k2, X, Y, Z, 'FaceColor', 'cyan', 'EdgeColor', 'k', ...
        'FaceAlpha', 1, 'DisplayName', 'Tumour');

% Extract vertices used by the convex hull.
Vertices = [X(k2(:,1)), Y(k2(:,1)), Z(k2(:,1));
            X(k2(:,2)), Y(k2(:,2)), Z(k2(:,2));
            X(k2(:,3)), Y(k2(:,3)), Z(k2(:,3))];

% Remove duplicate vertices.
VerticesUnique = unique(Vertices, 'rows');

% Plot the unique tumour surface points.
scatter3(VerticesUnique(:,1), VerticesUnique(:,2), VerticesUnique(:,3), ...
         40, 'r', 'filled', 'DisplayName', 'Tumour Surface Points');
end
