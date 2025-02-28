function generateLaserTrajectory(VerticesUnique, tolerance, numLaserSteps, startPt)
% generateLaserTrajectory - Computes, displays, and stores the laser tool trajectory.
%
% Syntax: generateLaserTrajectory(VerticesUnique, tolerance, numLaserSteps, startPt)
%
% Inputs:
%   VerticesUnique - Unique tumour surface points.
%   tolerance      - Offset distance (in mm) used to compute the deepest z.
%   numLaserSteps  - Number of steps for the vertical descent (and ascent).
%   startPt        - Precomputed starting point [x, y, z].
%
% Description:
%   The laser tool starts at the provided start point, descends vertically to the
%   deepest position (computed as z_bottom = min(VerticesUnique(:,3)) - tolerance),
%   then ascends back to the start. The trajectory is stored as a cell array with columns:
%   {x, y, z, label, theta_x, theta_y, theta_z}. Each step is printed to the command window.
%
% The resulting cell array is stored in the MATLAB workspace as "laserPath".

% Use the provided starting point
% startPt = [x, y, z] (already computed outside this function)

% Determine deepest z position
z_bottom = min(VerticesUnique(:,3)) - tolerance;

%% Generate vertical descent (from startPt to z_bottom)
laserDescendZ = linspace(startPt(3), z_bottom, numLaserSteps)';
descendCoords = [repmat(startPt(1), numLaserSteps, 1), ...
                 repmat(startPt(2), numLaserSteps, 1), ...
                 laserDescendZ, ...
                 zeros(numLaserSteps, 3)];  % Orientation fixed as [0,0,0]

%% Generate vertical ascent (from z_bottom back to startPt)
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

%% Create cell array for trajectory data:
% Columns: {x, y, z, label, theta_x, theta_y, theta_z}
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

%% Insert key messages into the cell array:
laserPath{1,4} = sprintf('Beginning of laser path at (%.4f, %.4f, %.4f).', startPt(1), startPt(2), startPt(3));
laserPath{numLaserSteps,4} = ['Laser has reached the deepest position at z = ', num2str(z_bottom), '.'];
laserPath{numLaserSteps+1,4} = 'Laser is shut off, returning to start position.';
laserPath{end,4} = 'Laser is at start position, laser''s job is done.';

%% Display the full trajectory on the command window:
disp('--- Laser Trajectory ---');
for i = 1:numTotalSteps
    fprintf('Step %d: x = %.4f, y = %.4f, z = %.4f, Orientation = [%.4f, %.4f, %.4f], Message: %s\n', ...
        i, laserPath{i,1}, laserPath{i,2}, laserPath{i,3}, ...
        laserPath{i,5}, laserPath{i,6}, laserPath{i,7}, laserPath{i,4});
end
disp('-------------------------');

%% Store the trajectory in the MATLAB base workspace
assignin('base', 'laserPath', laserPath);
end
