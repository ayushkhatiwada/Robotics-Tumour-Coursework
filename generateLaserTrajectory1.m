function laserPath = generateLaserTrajectory1(VerticesUnique, z_tolerance, startPt)
% generateLaserTrajectory1 - Computes, displays, and stores the first laser beam trajectory.
%
% Syntax: laserPath = generateLaserTrajectory1(VerticesUnique, z_tolerance, startPt)
%
% Inputs:
%   VerticesUnique - Unique tumour surface points.
%   z_tolerance    - Vertical offset (in mm) used to compute the deepest z.
%                    (z_bottom = min(VerticesUnique(:,3)) - z_tolerance)
%   startPt        - Precomputed starting point [x, y, z].
%
% Outputs:
%   laserPath - A cell array with columns {x, y, z, label, theta_x, theta_y, theta_z}
%               representing the trajectory of the laser beam.
%
% Description:
%   The laser beam starts at the provided start point, descends vertically to the
%   deepest position (z_bottom) and then ascends back to the start point.
%   The trajectory is printed step-by-step in the command window and stored in the MATLAB
%   base workspace as "laserBeamPath1".
%
% Example:
%   laserPath = generateLaserTrajectory1(VerticesUnique, 5, startPt);

    % Fixed number of steps for vertical descent/ascent
    numLaserSteps = 20;

    % Compute the deepest z position for the laser cut.
    z_bottom = min(VerticesUnique(:,3)) - z_tolerance;

    %% Compute vertical descent (from startPt to z_bottom)
    laserDescendZ = linspace(startPt(3), z_bottom, numLaserSteps)';
    descendCoords = [repmat(startPt(1), numLaserSteps, 1), ...
                     repmat(startPt(2), numLaserSteps, 1), ...
                     laserDescendZ, ...
                     zeros(numLaserSteps, 3)];  % Orientation fixed as [0,0,0]

    %% Compute vertical ascent (from z_bottom back to startPt)
    laserAscendZ = linspace(z_bottom, startPt(3), numLaserSteps)';
    ascendCoords = [repmat(startPt(1), numLaserSteps, 1), ...
                    repmat(startPt(2), numLaserSteps, 1), ...
                    laserAscendZ, ...
                    zeros(numLaserSteps, 3)];
    % Remove duplicate bottom point when concatenating
    ascendCoords = ascendCoords(2:end, :);

    %% Combine descent and ascent coordinates
    allCoords = [descendCoords; ascendCoords];
    numTotalSteps = size(allCoords, 1);

    %% Build the trajectory cell array:
    % Each row: {x, y, z, label, theta_x, theta_y, theta_z}
    laserPath = cell(numTotalSteps, 7);
    for i = 1:numTotalSteps
        laserPath{i,1} = allCoords(i,1);  % x
        laserPath{i,2} = allCoords(i,2);  % y
        laserPath{i,3} = allCoords(i,3);  % z
        laserPath{i,4} = '';              % label (to be updated)
        laserPath{i,5} = allCoords(i,4);  % theta_x (0)
        laserPath{i,6} = allCoords(i,5);  % theta_y (0)
        laserPath{i,7} = allCoords(i,6);  % theta_z (0)
    end

    %% Insert key messages:
    laserPath{1,4} = sprintf('Beginning of laser beam path at (%.4f, %.4f, %.4f).', startPt(1), startPt(2), startPt(3));
    laserPath{numLaserSteps,4} = sprintf('Laser beam reached deepest position at z = %.4f.', z_bottom);
    laserPath{numLaserSteps+1,4} = 'Laser is shut off, returning beam to start position.';
    laserPath{end,4} = 'Laser beam is at start position, laser''s job is done.';

    %% Enhanced display separators for clearer output:
    separator = repmat('=', 1, 70);
    fprintf('\n%s\n', separator);
    disp('           *** LASER BEAM TRAJECTORY 1 (VERTICAL CUT) ***           ');
    fprintf('%s\n\n', separator);

    for i = 1:numTotalSteps
        fprintf('Step %d: x = %.4f, y = %.4f, z = %.4f, Orientation = [%.4f, %.4f, %.4f], Message: %s\n', ...
            i, laserPath{i,1}, laserPath{i,2}, laserPath{i,3}, ...
            laserPath{i,5}, laserPath{i,6}, laserPath{i,7}, laserPath{i,4});
    end
    fprintf('\n%s\n\n', separator);

    %% Store the trajectory in the MATLAB base workspace as "laserBeamPath1"
    assignin('base', 'laserBeamPath1', laserPath);
end
