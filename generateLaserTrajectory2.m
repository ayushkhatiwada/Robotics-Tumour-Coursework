function laserPath2 = generateLaserTrajectory2(VerticesUnique, z_tolerance)
% generateLaserTrajectory2 - Computes, displays, and stores the horizontal laser trajectory (round trip)
%                             using a negative vertical offset (z_tolerance).
%
% Syntax: generateLaserTrajectory2(VerticesUnique, z_tolerance)
%
% Inputs:
%   VerticesUnique - Unique tumour surface points (Nx3 matrix with columns [x, y, z]).
%   z_tolerance    - Vertical offset (in mm) applied to the tumour's minimum z. For example,
%                    if z_tolerance is 5, the laser beam will be positioned 5 mm below the
%                    tumour's minimum z.
%
% Description:
%   The function computes the tumour's bounding box and defines the starting point for the
%   horizontal laser cut as (max_x, min_y, z_level), where 
%       z_level = min(VerticesUnique(:,3)) - z_tolerance.
%   The laser beam is assumed to be oriented horizontally with fixed orientation
%       [theta_x, theta_y, theta_z] = [90, 0, 0] (degrees),
%   so that it points toward decreasing x. The beam moves in a straight line from the starting
%   x position (max_x) to the minimum x value, then returns to the starting point along the same line.
%   Key messages are inserted into the trajectory data, the complete round-trip trajectory is printed,
%   and the resulting cell array is stored in the MATLAB base workspace as "laserPath2".

    % Fix the number of steps for the forward (or return) cut to 20
    numLaserSteps = 20;

    % Compute bounding box from tumour data
    min_x = min(VerticesUnique(:,1));
    max_x = max(VerticesUnique(:,1));
    min_y = min(VerticesUnique(:,2));
    min_z = min(VerticesUnique(:,3));
    
    % Define z_level as the tumour's minimum z minus z_tolerance
    z_level = min_z - z_tolerance;
    
    % Define starting point for the horizontal laser cut:
    % (max_x, min_y, z_level)
    startPoint = [max_x, min_y, z_level];
    
    % Define ending point for the forward cut (minimum x, same y and z)
    endPoint = [min_x, min_y, z_level];
    
    % Forward cut: linearly interpolate x from startPoint(1) to endPoint(1)
    x_forward = linspace(startPoint(1), endPoint(1), numLaserSteps)';
    % Return cut: interpolate x from endPoint(1) back to startPoint(1)
    x_return = linspace(endPoint(1), startPoint(1), numLaserSteps)';
    % Remove duplicate point (endPoint appears twice)
    x_return = x_return(2:end);
    
    % y and z remain constant for both segments
    y_forward = repmat(startPoint(2), numLaserSteps, 1);
    z_forward = repmat(startPoint(3), numLaserSteps, 1);
    
    y_return = repmat(startPoint(2), numLaserSteps-1, 1);
    z_return = repmat(startPoint(3), numLaserSteps-1, 1);
    
    % Combine forward and return segments
    x_values = [x_forward; x_return];
    y_values = [y_forward; y_return];
    z_values = [z_forward; z_return];
    
    % Total number of steps for the round trip
    numTotalSteps = length(x_values);
    
    % Fixed orientation for a horizontal beam pointing toward decreasing x:
    % Here, we set theta_x = 90 degrees (rotated to horizontal), theta_y = 0, theta_z = 0.
    fixedOrientation = [90, 0, 0];
    
    % Create cell array to hold the trajectory data.
    % Each row: {x, y, z, label, theta_x, theta_y, theta_z}
    laserPath2 = cell(numTotalSteps, 7);
    for i = 1:numTotalSteps
        laserPath2{i,1} = x_values(i);
        laserPath2{i,2} = y_values(i);
        laserPath2{i,3} = z_values(i);
        laserPath2{i,4} = ''; % label (to be updated below)
        laserPath2{i,5} = fixedOrientation(1);
        laserPath2{i,6} = fixedOrientation(2);
        laserPath2{i,7} = fixedOrientation(3);
    end
    
    % Insert key messages into the cell array:
    laserPath2{1,4} = sprintf('Beginning of horizontal laser beam path at (%.4f, %.4f, %.4f).', ...
                              startPoint(1), startPoint(2), startPoint(3));
    laserPath2{numLaserSteps,4} = sprintf('Horizontal cut complete: reached minimum x = %.4f.', endPoint(1));
    laserPath2{numLaserSteps+1,4} = 'Laser beam switched off, laser beam is returning to start position.';
    laserPath2{end,4} = sprintf('Return complete: laser beam is at start position (%.4f, %.4f, %.4f).', ...
                                startPoint(1), startPoint(2), startPoint(3));
    
    % Enhanced display separators for clearer output:
    separator = repmat('=', 1, 70);
    fprintf('\n%s\n', separator);
    disp('       *** LASER BEAM TRAJECTORY 2 (HORIZONTAL CUT) ***       ');
    fprintf('%s\n\n', separator);
    
    % Display the full trajectory in the command window:
    for i = 1:numTotalSteps
        fprintf('Step %d: x = %.4f, y = %.4f, z = %.4f, Orientation = [%.4f, %.4f, %.4f], Message: %s\n', ...
            i, laserPath2{i,1}, laserPath2{i,2}, laserPath2{i,3}, ...
            laserPath2{i,5}, laserPath2{i,6}, laserPath2{i,7}, laserPath2{i,4});
    end
    fprintf('\n%s\n\n', separator);
    
    % Store the trajectory in the MATLAB base workspace as "laserPath2"
    assignin('base', 'laserBeamPath2', laserPath2);
end
