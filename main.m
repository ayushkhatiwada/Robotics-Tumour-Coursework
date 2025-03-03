% main.m
clc;

% Load the tumour data (X, Y, Z coordinates)
load('X.mat'); % X coordinates of tumour surface
load('Y.mat'); % Y coordinates of tumour surface
load('Z.mat'); % Z coordinates of tumour surface

% Create figure for plotting
figure;
hold on;

% Plot the bone as a cuboid
plotBone();

% Plot the tumour (convex hull and unique surface points)
VerticesUnique = plotTumour(X, Y, Z);

% Compute and plot the bounding box for the tumour
[center, dims] = plotTumourBoundingBox(VerticesUnique);


%% Plot the outline of the tumour in the (x, y) plane
tolerance = 0;      % No outward offset for the outline
colour = "#EDB120"; % Colour for the outline
lineStyle = ':';    % Line style (dotted)
plotTumourOutline(VerticesUnique, tolerance, colour, lineStyle);


%% Plot the horizontal cut path (side walls of the cut)

% Additional depth the tools will cut in the z-direction
z_tolerance = 5;
% Outward offset distance for the cutting tool path
outwards_tolerance = 5;      
colour = 'm';       % Colour of the cutting tool path
plotHorizontalCutPath(VerticesUnique, outwards_tolerance, z_tolerance, colour);


%% Vertical Cuts of cutting tools (Laser & Cutting Tool Cut Trajectories)

% Offset (in mm) for the cutting path around the tumour
outwards_tolerance = 5;     

% Precompute the starting point for cutting tool path 1
startPt1 = calculateStartingPoint1(VerticesUnique, outwards_tolerance);

% Additional depth the tools will cut in the z-direction
z_tolerance = 5;

% Generate and display the position and orientation of the cuts for the 
% vertical cuts
laserBeamPath1 = generateLaserTrajectory1(VerticesUnique, z_tolerance, startPt1);
cuttingToolPath1 = generateCuttingToolTrajectory1(VerticesUnique, z_tolerance, startPt1);


%% Horizontal Cuts of cutting tools (Laser & Cutting Tool Cut Trajectories)

% Generate and display the position and orientation of the cuts for the 
% horizontal cuts
laserBeamPath2 = generateLaserTrajectory2(VerticesUnique, z_tolerance);
cuttingToolPath2 = generateCuttingToolTrajectory2(VerticesUnique, z_tolerance);


%% Animate
%animateCuttingPaths(laserBeamPath1, cuttingToolPath1, laserBeamPath2, cuttingToolPath2);


%% Final Plot Adjustments

% Set the axis properties and limits for better visualization
axis equal;
xlim([0 50]);    % Set x-axis limits
ylim([0 50]);    % Set y-axis limits
zlim([-30 20]);  % Set z-axis limits
xlabel('x (mm)');
ylabel('y (mm)');
zlabel('z (mm)');
grid on;          
view(3);          % Set 3D view
legend('Location','best');
title('Tumour and Bone Visualization with Bounding Box and Cutting Tool Path');

% Release hold for future plotting
hold off;
