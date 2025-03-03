function generateCuttingToolTrajectory2(VerticesUnique, z_tolerance)
% generateCuttingToolTrajectory2 - Computes, displays, and stores the second cutting path of the cutting tool.
%
% Syntax: generateCuttingToolTrajectory2(VerticesUnique, z_tolerance)
%
% Inputs:
%   VerticesUnique - Unique tumour surface points (Nx3 matrix: [x, y, z]).
%   z_tolerance    - Vertical offset (in mm) applied to the tumour's minimum z.
%                    The laser-made hole is at z_level = min(VerticesUnique(:,3)) - z_tolerance.
%
% Description:
%   The cutting tool, with fixed orientation [90, 0, 0], performs a horizontal cut.
%   It assumes the tool is already at the hole level at (max_x, min_y, z_level), where
%   z_level = min(VerticesUnique(:,3)) - z_tolerance. The tool then moves horizontally along
%   the y-axis from y = min_y to y = max_y (the forward cut) and then returns horizontally back
%   to the starting position. Key messages mark the beginning, the forward cut’s completion,
%   and the return.
%
% The complete trajectory (a cell array with columns {x, y, z, label, theta_x, theta_y, theta_z})
% is printed to the command window with enhanced separators and stored in the MATLAB base workspace
% as "cuttingToolPath2".

    % Fix the number of horizontal steps to 20 for both forward and return segments
    numHorizontalSteps = 20;
    
    % Compute bounding box parameters from tumour data
    max_x = max(VerticesUnique(:,1));
    min_y = min(VerticesUnique(:,2));
    max_y = max(VerticesUnique(:,2));
    min_z = min(VerticesUnique(:,3));
    
    % Define the z-level for the hole (same as the horizontal laser beam)
    z_level = min_z - z_tolerance;
    
    % Define the starting point for the horizontal cut:
    % (max_x, min_y, z_level)
    horizontalStart = [max_x, min_y, z_level];
    
    % Part 1: Horizontal forward cut along the y-axis (at hole level)
    % From (max_x, min_y, z_level) to (max_x, max_y, z_level)
    y_forward = linspace(min_y, max_y, numHorizontalSteps)';
    horizontalForward = [repmat(max_x, numHorizontalSteps, 1), y_forward, repmat(z_level, numHorizontalSteps, 1), zeros(numHorizontalSteps, 3)];
    
    % Part 2: Horizontal return cut along the y-axis (at hole level)
    % From (max_x, max_y, z_level) to (max_x, min_y, z_level)
    y_return = linspace(max_y, min_y, numHorizontalSteps)';
    % Remove duplicate point at the junction:
    y_return = y_return(2:end);
    horizontalReturn = [repmat(max_x, length(y_return), 1), y_return, repmat(z_level, length(y_return), 1), zeros(length(y_return), 3)];
    
    % Combine forward and return segments
    allCoords = [horizontalForward; horizontalReturn];
    numTotalSteps = size(allCoords, 1);
    
    % Fixed orientation for the tool (horizontal): [theta_x, theta_y, theta_z] = [90, 0, 0]
    fixedOrientation = [90, 0, 0];
    
    % Create a cell array for trajectory data with columns:
    % {x, y, z, label, theta_x, theta_y, theta_z}
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
    cuttingToolPath2{1,4} = sprintf('Beginning of horizontal cutting tool path at (%.4f, %.4f, %.4f).', horizontalStart(1), horizontalStart(2), horizontalStart(3));
    cuttingToolPath2{numHorizontalSteps,4} = sprintf('Cutting tool reached bottom right of bounding box at (%.4f, %.4f, %.4f).', max_x, max_y, z_level);
    cuttingToolPath2{end,4} = sprintf('Cutting tool has returned horizontally to start position (%.4f, %.4f, %.4f).', horizontalStart(1), horizontalStart(2), horizontalStart(3));
    
    % Enhanced display separators for clearer output:
    separator = repmat('=', 1, 70);
    fprintf('\n%s\n', separator);
    disp('       *** CUTTING TOOL TRAJECTORY 2 (HORIZONTAL CUT) ***       ');
    fprintf('%s\n\n', separator);
    
    % Display the full trajectory in the command window:
    for i = 1:numTotalSteps
        fprintf('Step %d: x = %.4f, y = %.4f, z = %.4f, Orientation = [%.4f, %.4f, %.4f], Message: %s\n', ...
            i, cuttingToolPath2{i,1}, cuttingToolPath2{i,2}, cuttingToolPath2{i,3}, ...
            cuttingToolPath2{i,5}, cuttingToolPath2{i,6}, cuttingToolPath2{i,7}, cuttingToolPath2{i,4});
    end
    fprintf('\n%s\n\n', separator);
    
    % Store the trajectory in the MATLAB base workspace as "cuttingToolPath2"
    assignin('base', 'cuttingToolPath2', cuttingToolPath2);
end
