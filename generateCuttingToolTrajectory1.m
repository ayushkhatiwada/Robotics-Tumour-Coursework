function cuttingToolPath = generateCuttingToolTrajectory1(VerticesUnique, z_tolerance, startPt)
% generateCuttingToolTrajectory1 - Computes, displays, and stores the cutting tool's second trajectory.
%
% Syntax: cuttingToolPath = generateCuttingToolTrajectory1(VerticesUnique, z_tolerance, startPt)
%
% Inputs:
%   VerticesUnique  - Unique tumour surface points.
%   z_tolerance     - Offset distance for the cutting path (in mm).
%                     (z_bottom = min(VerticesUnique(:,3)) - z_tolerance)
%   startPt         - Precomputed starting point [x, y, z].
%
% Description:
%   The cutting tool starts at the provided start point, descends vertically to the cutting
%   depth (z_bottom) then moves laterally along an offset convex hull (the cutting path)
%   at that depth, and finally ascends back to the start.
%   The trajectory is stored as a cell array with columns:
%       {x, y, z, label, theta_x, theta_y, theta_z}.
%   Each step is printed to the command window.
%
% The resulting cell array is stored in the MATLAB workspace as "cuttingToolPath1"
% and is also returned by the function.

    % Fix the number of vertical steps to 20
    numVerticalSteps = 20;

    % Determine cutting depth (same as laser deepest position)
    z_bottom = min(VerticesUnique(:,3)) - z_tolerance;

    %% Part 1: Vertical descent from startPt to z_bottom
    descentZ = linspace(startPt(3), z_bottom, numVerticalSteps)';
    verticalDescent = [repmat(startPt(1), numVerticalSteps, 1), ...
                       repmat(startPt(2), numVerticalSteps, 1), ...
                       descentZ, ...
                       zeros(numVerticalSteps, 3)];

    %% Part 2: Lateral movement along the cutting path at cutting depth
    % Compute convex hull in the x-y plane
    k_xy = convhull(VerticesUnique(:,1), VerticesUnique(:,2));
    x_hull = VerticesUnique(k_xy, 1);
    y_hull = VerticesUnique(k_xy, 2);
    % Create a polyshape and apply an outward offset using z_tolerance
    tumourPoly = polyshape(x_hull, y_hull);
    offsetPoly = polybuffer(tumourPoly, z_tolerance);
    [x_boundary, y_boundary] = boundary(offsetPoly);
    % Ensure closed loop
    x_boundary = [x_boundary; x_boundary(1)];
    y_boundary = [y_boundary; y_boundary(1)];
    % Force lateral path to start and end at the computed (x,y) start point:
    lateralXY = [startPt(1:2); [x_boundary, y_boundary]; startPt(1:2)];
    numLateralPoints = size(lateralXY, 1);
    lateralMovement = [lateralXY, repmat(z_bottom, numLateralPoints, 1), zeros(numLateralPoints, 3)];

    %% Part 3: Vertical ascent from z_bottom back to startPt
    ascentZ = linspace(z_bottom, startPt(3), numVerticalSteps)';
    verticalAscent = [repmat(startPt(1), numVerticalSteps, 1), ...
                      repmat(startPt(2), numVerticalSteps, 1), ...
                      ascentZ, ...
                      zeros(numVerticalSteps, 3)];

    %% Combine all segments into the full trajectory
    allCoords = [verticalDescent; lateralMovement; verticalAscent];
    numTotalSteps = size(allCoords, 1);

    %% Create cell array for trajectory data:
    % Columns: {x, y, z, label, theta_x, theta_y, theta_z}
    cuttingToolPath = cell(numTotalSteps, 7);
    for i = 1:numTotalSteps
        cuttingToolPath{i,1} = allCoords(i,1);
        cuttingToolPath{i,2} = allCoords(i,2);
        cuttingToolPath{i,3} = allCoords(i,3);
        cuttingToolPath{i,4} = '';  % label (to be updated)
        cuttingToolPath{i,5} = allCoords(i,4);
        cuttingToolPath{i,6} = allCoords(i,5);
        cuttingToolPath{i,7} = allCoords(i,6);
    end

    %% Insert key messages:
    cuttingToolPath{1,4} = sprintf('Beginning of cutting tool path at (%.4f, %.4f, %.4f).', startPt(1), startPt(2), startPt(3));
    cuttingToolPath{numVerticalSteps,4} = sprintf('Cutting tool reached cutting depth at z = %.4f.', z_bottom);
    cuttingToolPath{numVerticalSteps+1,4} = 'Cutting tool is now cutting around the tumour.';
    cuttingToolPath{numVerticalSteps + numLateralPoints,4} = sprintf('Cutting tool completed the lateral path and is returning to (%.4f, %.4f, %.4f).', startPt(1), startPt(2), z_bottom);
    cuttingToolPath{end,4} = 'Cutting tool is at start position, cutting job is done.';

    %% Enhanced display separators for clearer output:
    separator = repmat('=', 1, 70);
    fprintf('\n%s\n', separator);
    disp('         *** CUTTING TOOL TRAJECTORY 1 (VERTICAL CUT) ***         ');
    fprintf('%s\n\n', separator);

    for i = 1:numTotalSteps
        fprintf('Step %d: x = %.4f, y = %.4f, z = %.4f, Orientation = [%.4f, %.4f, %.4f], Message: %s\n', ...
            i, cuttingToolPath{i,1}, cuttingToolPath{i,2}, cuttingToolPath{i,3}, ...
            cuttingToolPath{i,5}, cuttingToolPath{i,6}, cuttingToolPath{i,7}, cuttingToolPath{i,4});
    end
    fprintf('\n%s\n\n', separator);

    %% Store the trajectory in the MATLAB base workspace as "cuttingToolPath1"
    assignin('base', 'cuttingToolPath1', cuttingToolPath);
end
