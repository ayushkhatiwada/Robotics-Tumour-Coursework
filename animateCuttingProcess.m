function animateCuttingProcess(laserPath, cuttingToolPath)
% animateCuttingProcess - Animates the cutting process over time.
%
% Syntax: animateCuttingProcess(laserPath, cuttingToolPath)
%
% Inputs:
%   laserPath      - Cell array of the laser trajectory with columns:
%                    {x, y, z, label, theta_x, theta_y, theta_z}
%   cuttingToolPath- Cell array of the cutting tool trajectory with columns:
%                    {x, y, z, label, theta_x, theta_y, theta_z}
%
% Description:
%   This function displays an animated 3D plot showing the progression of the 
%   laser tool (blue) and the cutting tool (red) along their respective trajectories.
%   At each step, the function updates the plot markers and draws a line connecting
%   the points visited so far. Key messages for each step are also printed to the 
%   command window.
%
% Example:
%   animateCuttingProcess(laserPath, cuttingToolPath);
%
% Note: Adjust the pause duration (currently set to 0.1 sec) as needed.

% Create a new figure for the animation
figure;
hold on;
grid on;
axis equal;
xlabel('X (mm)');
ylabel('Y (mm)');
zlabel('Z (mm)');
title('Cutting Process Animation');

% Set axis limits based on trajectory data (adjust as needed)
allX = [cell2mat(laserPath(:,1)); cell2mat(cuttingToolPath(:,1))];
allY = [cell2mat(laserPath(:,2)); cell2mat(cuttingToolPath(:,2))];
allZ = [cell2mat(laserPath(:,3)); cell2mat(cuttingToolPath(:,3))];
xlim([min(allX)-5, max(allX)+5]);
ylim([min(allY)-5, max(allY)+5]);
zlim([min(allZ)-5, max(allZ)+5]);

% --- Animate Laser Tool Trajectory ---
nLaser = size(laserPath, 1);
% Create plot objects for the laser tool (blue)
laserLine = plot3(nan, nan, nan, 'b-', 'LineWidth', 2);
laserMarker = plot3(nan, nan, nan, 'bo', 'MarkerSize', 8, 'MarkerFaceColor', 'b');

fprintf('\n%s\n', repmat('=',1,70));
disp('           *** ANIMATING LASER TRAJECTORY ***           ');
fprintf('%s\n', repmat('=',1,70));

for i = 1:nLaser
    % Get current position from laserPath (numeric values)
    x = laserPath{i,1};
    y = laserPath{i,2};
    z = laserPath{i,3};
    
    % Update the laser line with all points visited so far
    if i == 1
        set(laserLine, 'XData', x, 'YData', y, 'ZData', z);
    else
        Xdata = get(laserLine, 'XData');
        Ydata = get(laserLine, 'YData');
        Zdata = get(laserLine, 'ZData');
        set(laserLine, 'XData', [Xdata, x], 'YData', [Ydata, y], 'ZData', [Zdata, z]);
    end
    % Update marker position
    set(laserMarker, 'XData', x, 'YData', y, 'ZData', z);
    
    % If there's a key message at this step, print it.
    msg = laserPath{i,4};
    if ~isempty(msg)
        fprintf('Laser Step %d: %s\n', i, msg);
    end
    pause(0.1); % Adjust the pause time for desired animation speed
end

fprintf('\n%s\n\n', repmat('=',1,70));
pause(1); % Pause between phases

% --- Animate Cutting Tool Trajectory ---
nCut = size(cuttingToolPath, 1);
% Create plot objects for the cutting tool (red)
cutLine = plot3(nan, nan, nan, 'r-', 'LineWidth', 2);
cutMarker = plot3(nan, nan, nan, 'ro', 'MarkerSize', 8, 'MarkerFaceColor', 'r');

fprintf('\n%s\n', repmat('=',1,70));
disp('         *** ANIMATING CUTTING TOOL TRAJECTORY ***         ');
fprintf('%s\n', repmat('=',1,70));

for i = 1:nCut
    % Get current position from cuttingToolPath
    x = cuttingToolPath{i,1};
    y = cuttingToolPath{i,2};
    z = cuttingToolPath{i,3};
    
    % Update the cutting tool line with all visited points so far
    if i == 1
        set(cutLine, 'XData', x, 'YData', y, 'ZData', z);
    else
        Xdata = get(cutLine, 'XData');
        Ydata = get(cutLine, 'YData');
        Zdata = get(cutLine, 'ZData');
        set(cutLine, 'XData', [Xdata, x], 'YData', [Ydata, y], 'ZData', [Zdata, z]);
    end
    % Update marker position
    set(cutMarker, 'XData', x, 'YData', y, 'ZData', z);
    
    % If there's a key message at this step, print it.
    msg = cuttingToolPath{i,4};
    if ~isempty(msg)
        fprintf('Cutting Tool Step %d: %s\n', i, msg);
    end
    pause(0.1); % Adjust pause for animation speed
end

fprintf('\n%s\n\n', repmat('=',1,70));

hold off;
end
