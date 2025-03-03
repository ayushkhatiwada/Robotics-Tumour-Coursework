function animateCuttingPaths(laserBeamPath1, cuttingToolPath1, laserBeamPath2, cuttingToolPath2, VerticesUnique, delayBetweenSteps)
% animateCuttingPaths - Animates the four cutting paths sequentially on the same figure.
%
% Syntax: animateCuttingPaths(laserBeamPath1, cuttingToolPath1, laserBeamPath2, cuttingToolPath2, VerticesUnique, delayBetweenSteps)
%
% Inputs:
%   laserBeamPath1    - Cell array containing the first laser beam path (vertical).
%   cuttingToolPath1  - Cell array containing the first cutting tool path.
%   laserBeamPath2    - Cell array containing the second laser beam path (horizontal).
%   cuttingToolPath2  - Cell array containing the second cutting tool path.
%   VerticesUnique    - Matrix containing the unique tumour surface points.
%   delayBetweenSteps - (Optional) Delay between animation steps in seconds (default: 0.05).
%
% Description:
%   This function creates a 3D visualization and animates the four cutting paths sequentially.
%   Each path is displayed in a different color with appropriate labels.
%   - Laser Beam Path 1 (Vertical Cut): Red
%   - Cutting Tool Path 1: Blue
%   - Laser Beam Path 2 (Horizontal Cut): Magenta
%   - Cutting Tool Path 2: Green
%
% Example:
%   animateCuttingPaths(laserBeamPath1, cuttingToolPath1, laserBeamPath2, cuttingToolPath2, VerticesUnique);

    % Set default delay if not provided
    if nargin < 6
        delayBetweenSteps = 0.05; % Default delay between steps (seconds)
    end
    
    % Create a new figure with specified size and position
    h_fig = figure('Name', 'Surgical Cutting Paths Animation', ...
                  'Position', [100, 100, 1000, 800], ...
                  'Color', 'white');
    
    % Define colors for each path
    laser1_color = 'r';   % Red for first laser beam
    tool1_color = 'b';    % Blue for first cutting tool
    laser2_color = 'm';   % Magenta for second laser beam
    tool2_color = 'g';    % Green for second cutting tool
    
    % Initialize 3D plot and display the tumour surface
    ax = axes('Parent', h_fig);
    hold(ax, 'on');
    
    % Plot the tumour surface points without adding to the legend directly
    scatter3(ax, VerticesUnique(:,1), VerticesUnique(:,2), VerticesUnique(:,3), 10, 'k', 'filled', 'MarkerFaceAlpha', 0.3, 'HandleVisibility', 'off');
    
    % Calculate the bounding box of the tumour for better view setting
    x_min = min(VerticesUnique(:,1));
    x_max = max(VerticesUnique(:,1));
    y_min = min(VerticesUnique(:,2));
    y_max = max(VerticesUnique(:,2));
    z_min = min(VerticesUnique(:,3));
    z_max = max(VerticesUnique(:,3));
    
    % Calculate depth offset (used in cutting paths)
    z_min_offset = z_min - 10; % Assume a reasonable offset
    
    % Set axis limits with a margin
    margin = 20; % Add some margin for better visualization
    xlim(ax, [x_min - margin, x_max + margin]);
    ylim(ax, [y_min - margin, y_max + margin]);
    zlim(ax, [z_min_offset - margin, z_max + margin]);
    
    % Set plot properties
    grid(ax, 'on');
    box(ax, 'on');
    axis(ax, 'equal');
    view(ax, 3); % Set to default 3D view
    
    % Add labels, title and legend
    xlabel(ax, 'X (mm)');
    ylabel(ax, 'Y (mm)');
    zlabel(ax, 'Z (mm)');
    title(ax, 'Tumour Resection Tool Path Animation');
    
    % Create legend handles - creating invisible objects with proper labels for the legend
    h_laser1 = plot3(NaN, NaN, NaN, 'Color', laser1_color, 'LineWidth', 2, 'DisplayName', 'Laser Beam Path 1 (Vertical)');
    h_tool1 = plot3(NaN, NaN, NaN, 'Color', tool1_color, 'LineWidth', 2, 'DisplayName', 'Cutting Tool Path 1');
    h_laser2 = plot3(NaN, NaN, NaN, 'Color', laser2_color, 'LineWidth', 2, 'DisplayName', 'Laser Beam Path 2 (Horizontal)');
    h_tool2 = plot3(NaN, NaN, NaN, 'Color', tool2_color, 'LineWidth', 2, 'DisplayName', 'Cutting Tool Path 2');
    h_tumor = scatter3(NaN, NaN, NaN, 10, 'k', 'filled', 'DisplayName', 'Tumour Surface');
    legend([h_laser1, h_tool1, h_laser2, h_tool2, h_tumor], 'Location', 'northeast');
    
    % Create text objects for step information and messages
    h_step_info = text(ax, x_min, y_max + margin/2, z_max + margin/2, '', 'FontSize', 12);
    h_message = text(ax, x_min, y_max + margin/2, z_max + margin/2 - 5, '', 'FontSize', 10);
    
    % Create a colormap for the orientation vectors
    cmap = hsv(36); % 360 degrees with 10-degree intervals
    
    % Animation function to animate a path
    function animatePath(path, pathName, pathColor)
        % Plot the full path as a thin line for reference without adding a legend entry
        x_all = cellfun(@(c) c, path(:,1));
        y_all = cellfun(@(c) c, path(:,2));
        z_all = cellfun(@(c) c, path(:,3));
        plot3(ax, x_all, y_all, z_all, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.5, 'HandleVisibility', 'off');
        
        % Initialize current point marker without adding it to the legend
        h_current = plot3(ax, path{1,1}, path{1,2}, path{1,3}, 'o', ...
                          'MarkerFaceColor', pathColor, ...
                          'MarkerEdgeColor', 'k', ...
                          'MarkerSize', 8, ...
                          'HandleVisibility', 'off');
        
        % Removed orientation line as requested
        
        % Initialize path trace without adding it to the legend
        h_trace = plot3(ax, path{1,1}, path{1,2}, path{1,3}, ...
                        'LineWidth', 2, 'Color', pathColor, ...
                        'HandleVisibility', 'off');
        
        % Update title with current path name
        title(ax, ['Tumour Resection Tool Path Animation: ' pathName]);
        
        % Animation loop
        for i = 1:size(path, 1)
            % Get current coordinates
            x_cur = path{i,1};
            y_cur = path{i,2};
            z_cur = path{i,3};
            
            % Get orientation angles and convert to direction vector
            theta_x = path{i,5}; % Rotation around x-axis (pitch)
            theta_y = path{i,6}; % Rotation around y-axis (yaw)
            theta_z = path{i,7}; % Rotation around z-axis (roll)
            
            % Removed direction vector calculation as orientation arrows are no longer needed
            
            % Update the current position marker
            set(h_current, 'XData', x_cur, 'YData', y_cur, 'ZData', z_cur);
            
            % Removed orientation line update
            
            % Update the trace (accumulated path)
            x_trace = cellfun(@(c) c, path(1:i,1));
            y_trace = cellfun(@(c) c, path(1:i,2));
            z_trace = cellfun(@(c) c, path(1:i,3));
            set(h_trace, 'XData', x_trace, 'YData', y_trace, 'ZData', z_trace);
            
            % Update step information and message
            set(h_step_info, 'String', sprintf('%s: Step %d of %d', pathName, i, size(path, 1)));
            set(h_message, 'String', path{i,4});
            
            % Update the plot
            drawnow;
            
            % Pause to control animation speed
            pause(delayBetweenSteps);
        end
        
        % Keep the final trace visible
        % But remove the current point marker for cleaner visualization
        delete(h_current);
    end
    
    % Animate each path sequentially
    animatePath(laserBeamPath1, 'Laser Beam Path 1 (Vertical Cut)', laser1_color);
    pause(1); % Pause between paths
    
    animatePath(cuttingToolPath1, 'Cutting Tool Path 1', tool1_color);
    pause(1); % Pause between paths
    
    animatePath(laserBeamPath2, 'Laser Beam Path 2 (Horizontal Cut)', laser2_color);
    pause(1); % Pause between paths
    
    animatePath(cuttingToolPath2, 'Cutting Tool Path 2', tool2_color);
    
    % Final message
    set(h_step_info, 'String', 'Animation Complete');
    set(h_message, 'String', 'All cutting paths have been visualized');
    
    % Display the final view with all paths
    title(ax, 'Tumour Resection Complete: All Cutting Paths');
end