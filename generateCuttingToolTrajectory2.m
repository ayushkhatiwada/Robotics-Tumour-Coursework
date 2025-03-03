function cuttingToolPath2 = generateCuttingToolTrajectory2(VerticesUnique, z_tolerance)
% generateCuttingToolTrajectory2 - Computes, displays, and stores the second cutting path of the cutting tool.
%
% Syntax: cuttingToolPath2 = generateCuttingToolTrajectory2(VerticesUnique, z_tolerance)
%
% Inputs:
%   VerticesUnique - Unique tumour surface points (Nx3 matrix: [x, y, z]).
%   z_tolerance    - Vertical offset (in mm) applied to the tumour's minimum z.
%                    (The laser-made hole is at z_level = min(VerticesUnique(:,3)) - z_tolerance)
%
% Outputs:
%   cuttingToolPath2 - A cell array with columns {x, y, z, label, theta_x, theta_y, theta_z}
%                      representing the trajectory of the cutting tool.
%
% Description:
%   The cutting tool is assumed to be at the hole level at (max_x, min_y, z_level) and with fixed orientation [90, 0, 0].
%   It first enters the hole by moving horizontally along the x-axis from (max_x, min_y, z_level) to (min_x, min_y, z_level),
%   then cuts along the y-axis from (min_x, min_y, z_level) to (min_x, max_y, z_level),
%   and finally exits the hole along the x-axis from (min_x, max_y, z_level) to (max_x, max_y, z_level).
%   The resulting trajectory is printed step-by-step and stored in the MATLAB base workspace as "cuttingToolPath2".
%
% Example:
%   cuttingToolPath2 = generateCuttingToolTrajectory2(VerticesUnique, 5);

    % Fix the number of steps for each horizontal segment to 20
    numSteps = 20;
    
    % Compute bounding box parameters from tumour data
    max_x = max(VerticesUnique(:,1));
    min_x = min(VerticesUnique(:,1));
    min_y = min(VerticesUnique(:,2));
    max_y = max(VerticesUnique(:,2));
    min_z = min(VerticesUnique(:,3));
    
    % Define the z-level for the hole
    z_level = min_z - z_tolerance;
    
    % Segment 1: Horizontal Entry (along x-axis, from right edge to left edge)
    % From (max_x, min_y, z_level) to (min_x, min_y, z_level)
    x_entry = linspace(max_x, min_x, numSteps)';
    y_entry = repmat(min_y, numSteps, 1);
    z_entry = repmat(z_level, numSteps, 1);
    entrySegment = [x_entry, y_entry, z_entry, zeros(numSteps, 3)];
    
    % Segment 2: Horizontal Cut along y-axis
    % From (min_x, min_y, z_level) to (min_x, max_y, z_level)
    y_cut = linspace(min_y, max_y, numSteps)';
    x_cut = repmat(min_x, numSteps, 1);
    z_cut = repmat(z_level, numSteps, 1);
    cutSegment = [x_cut, y_cut, z_cut, zeros(numSteps, 3)];
    
    % Segment 3: Horizontal Exit (along x-axis)
    % From (min_x, max_y, z_level) to (max_x, max_y, z_level)
    x_exit = linspace(min_x, max_x, numSteps)';
    y_exit = repmat(max_y, numSteps, 1);
    z_exit = repmat(z_level, numSteps, 1);
    exitSegment = [x_exit, y_exit, z_exit, zeros(numSteps, 3)];
    
    % Combine all segments into one trajectory.
    allCoords = [entrySegment; cutSegment; exitSegment];
    numTotalSteps = size(allCoords, 1);
    
    % Fixed orientation for horizontal movement: [theta_x, theta_y, theta_z] = [90, 0, 0]
    fixedOrientation = [90, 0, 0];
    
    % Build the trajectory cell array.
    cuttingToolPath2 = cell(numTotalSteps, 7);
    for i = 1:numTotalSteps
        cuttingToolPath2{i,1} = allCoords(i,1);
        cuttingToolPath2{i,2} = allCoords(i,2);
        cuttingToolPath2{i,3} = allCoords(i,3);
        cuttingToolPath2{i,4} = '';  % label (to be updated)
        cuttingToolPath2{i,5} = fixedOrientation(1);
        cuttingToolPath2{i,6} = fixedOrientation(2);
        cuttingToolPath2{i,7} = fixedOrientation(3);
    end
    
    % Insert key messages:
    cuttingToolPath2{1,4} = sprintf('Beginning of cutting tool horizontal entry at (%.4f, %.4f, %.4f).', max_x, min_y, z_level);
    cuttingToolPath2{numSteps,4} = sprintf('Cutting tool reached the bottom of the hole at (%.4f, %.4f, %.4f).', min_x, min_y, z_level);
    cuttingToolPath2{numSteps+1,4} = 'Cutting tool is cutting horizontally along the y-axis.';
    cuttingToolPath2{2*numSteps,4} = sprintf('Cutting tool reached bottom right at (%.4f, %.4f, %.4f). Exiting hole now', min_x, max_y, z_level);
    cuttingToolPath2{end,4} = sprintf('Cutting tool exited the hole at (%.4f, %.4f, %.4f).', max_x, max_y, z_level);
    
    % Enhanced display separators:
    separator = repmat('=', 1, 70);
    fprintf('\n%s\n', separator);
    disp('       *** CUTTING TOOL TRAJECTORY 2 (HORIZONTAL CUT) ***       ');
    fprintf('%s\n\n', separator);
    
    % Display the full trajectory:
    for i = 1:numTotalSteps
        fprintf('Step %d: x = %.4f, y = %.4f, z = %.4f, Orientation = [%.4f, %.4f, %.4f], Message: %s\n', ...
            i, cuttingToolPath2{i,1}, cuttingToolPath2{i,2}, cuttingToolPath2{i,3}, ...
            cuttingToolPath2{i,5}, cuttingToolPath2{i,6}, cuttingToolPath2{i,7}, cuttingToolPath2{i,4});
    end
    fprintf('\n%s\n\n', separator);
    
    % Store the trajectory in the MATLAB base workspace as "cuttingToolPath2"
    assignin('base', 'cuttingToolPath2', cuttingToolPath2);
end
