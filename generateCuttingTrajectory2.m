function generateCuttingTrajectory2(VerticesUnique, z_tolerance, numVerticalSteps, numHorizontalSteps)
% generateCuttingTrajectory2 - Computes, displays, and stores the second cutting path of the cutting tool.
%
% Syntax: generateCuttingTrajectory2(VerticesUnique, z_tolerance, numVerticalSteps, numHorizontalSteps)
%
% Inputs:
%   VerticesUnique     - Unique tumour surface points (Nx3 matrix: [x, y, z]).
%   z_tolerance        - Vertical offset (in mm) applied to the tumour's minimum z.
%                        The laser-made hole is at z_level = min(VerticesUnique(:,3)) - z_tolerance.
%   numVerticalSteps   - Number of steps for the vertical descent into the hole.
%   numHorizontalSteps - Number of steps for each horizontal (forward/return) cut along the y-axis.
%
% Description:
%   The cutting tool, with fixed orientation [90, 0, 0], begins above the hole.
%   It first lowers vertically from (max_x, min_y, z_level + descent_offset) to 
%   (max_x, min_y, z_level), where z_level is defined as (min_z - z_tolerance) and 
%   descent_offset is set to 5 mm. Then, at the hole level, it moves horizontally 
%   (with x fixed at max_x and z fixed at z_level) from y = min_y to y = max_y, reaching
%   the "bottom right" of the bounding box. Finally, it returns horizontally back to 
%   (max_x, min_y, z_level). Key messages mark the beginning, the completion of the 
%   vertical descent, the forward horizontal cut, and the return.
%
% The complete trajectory (a cell array with columns {x, y, z, label, theta_x, theta_y, theta_z})
% is printed to the command window with enhanced separators and stored in the MATLAB base workspace
% as "cuttingToolPath2".

    % Compute bounding box parameters from tumour data
    max_x = max(VerticesUnique(:,1));
    min_y = min(VerticesUnique(:,2));
    max_y = max(VerticesUnique(:,2));
    min_z = min(VerticesUnique(:,3));
    
    % Define the z-level for the hole (same as the horizontal laser beam)
    z_level = min_z - z_tolerance;
    
    % Define a vertical descent offset (how far above the hole the tool starts)
    descent_offset = 5;  % mm (this value may be adjusted)
    
    % Part 1: Vertical descent into the hole
    % Start above the hole: (max_x, min_y, z_level + descent_offset)
    verticalStart = [max_x, min_y, z_level + descent_offset];
    % End at the hole level: (max_x, min_y, z_level)
    verticalEnd = [max_x, min_y, z_level];
    z_vertical = linspace(verticalStart(3), verticalEnd(3), numVerticalSteps)';
    verticalDescent = [repmat(max_x, numVerticalSteps, 1), repmat(min_y, numVerticalSteps, 1), z_vertical, zeros(numVerticalSteps, 3)];
    
    % Part 2: Horizontal forward cut along y axis (at hole level)
    % From (max_x, min_y, z_level) to (max_x, max_y, z_level)
    y_forward = linspace(min_y, max_y, numHorizontalSteps)';
    horizontalForward = [repmat(max_x, numHorizontalSteps, 1), y_forward, repmat(z_level, numHorizontalSteps, 1), zeros(numHorizontalSteps, 3)];
    
    % Part 3: Horizontal return cut (back along y axis)
    % From (max_x, max_y, z_level) to (max_x, min_y, z_level)
    y_return = linspace(max_y, min_y, numHorizontalSteps)';
    % Remove duplicate endpoint at the junction with horizontalForward:
    y_return = y_return(2:end);
    horizontalReturn = [repmat(max_x, length(y_return), 1), y_return, repmat(z_level, length(y_return), 1), zeros(length(y_return), 3)];
    
    % Combine segments:
    % Total trajectory = vertical descent + horizontal forward + horizontal return.
    allCoords = [verticalDescent; horizontalForward; horizontalReturn];
    numTotalSteps = size(allCoords, 1);
    
    % Fixed orientation for the tool: same as horizontal laser, i.e., [theta_x, theta_y, theta_z] = [90, 0, 0].
    fixedOrientation = [90, 0, 0];
    
    % Create cell array for trajectory data with 7 columns: {x, y, z, label, theta_x, theta_y, theta_z}
    cuttingToolPath2 = cell(numTotalSteps, 7);
    for i = 1:numTotalSteps
        cuttingToolPath2{i,1} = allCoords(i,1);
        cuttingToolPath2{i,2} = allCoords(i,2);
        cuttingToolPath2{i,3} = allCoords(i,3);
        cuttingToolPath2{i,4} = '';  % label (to be updated below)
        cuttingToolPath2{i,5} = fixedOrientation(1);
        cuttingToolPath2{i,6} = fixedOrientation(2);
        cuttingToolPath2{i,7} = fixedOrientation(3);
    end
    
    % Insert key messages into the cell array:
    cuttingToolPath2{1,4} = sprintf('Beginning of cutting tool second path at (%.4f, %.4f, %.4f).', verticalStart(1), verticalStart(2), verticalStart(3));
    cuttingToolPath2{numVerticalSteps,4} = sprintf('Cutting tool lowered into the hole at (%.4f, %.4f, %.4f).', verticalEnd(1), verticalEnd(2), verticalEnd(3));
    cuttingToolPath2{numVerticalSteps + numHorizontalSteps,4} = sprintf('Cutting tool reached bottom right of bounding box at (%.4f, %.4f, %.4f).', max_x, max_y, z_level);
    cuttingToolPath2{end,4} = sprintf('Cutting tool has moved horizontally out of the hole, returning to (%.4f, %.4f, %.4f).', max_x, min_y, z_level);
    
    % Enhanced display separators for clearer output:
    separator = repmat('=',1,70);
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
