function startPt = calculateStartingPoint1(VerticesUnique, tolerance)
% calculateStartingPoint1 - Computes the first starting point based on tumour data.
%
% Syntax: startPt = calculateStartingPoint1(VerticesUnique, tolerance)
%
% Inputs:
%   VerticesUnique - A matrix of tumour surface points [x, y, z].
%   tolerance      - Offset distance (in mm) for the convex hull (e.g., 5 mm).
%
% Outputs:
%   startPt - A 1×3 vector [x, y, z] representing the calculated starting point.
%
% Example:
%   startPt = calculateStartingPoint1(VerticesUnique, 5);

    % Compute convex hull in the x-y plane
    k_xy = convhull(VerticesUnique(:,1), VerticesUnique(:,2));
    x_hull = VerticesUnique(k_xy, 1);
    y_hull = VerticesUnique(k_xy, 2);
    
    % Create a polyshape and offset it outward by 'tolerance'
    tumourPoly = polyshape(x_hull, y_hull);
    offsetPoly = polybuffer(tumourPoly, tolerance);
    
    % Extract the boundary of the offset polygon
    [x_boundary, y_boundary] = boundary(offsetPoly);
    
    % Select the first boundary point
    startX = x_boundary(1);
    startY = y_boundary(1);
    
    % Assume the top surface is given by the maximum z value in VerticesUnique
    topSurface = max(VerticesUnique(:,3));
    
    % deltaZ is now fixed to 0
    startZ = topSurface;
    
    % Form the starting point
    startPt = [startX, startY, startZ];
    
    % Display the calculated starting point
    fprintf('Calculated starting point: (%.4f, %.4f, %.4f)\n', startPt(1), startPt(2), startPt(3));
end
