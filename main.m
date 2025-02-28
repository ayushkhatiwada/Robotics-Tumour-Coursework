% main.m
clc;

% Load the data
load('X.mat'); % Contains variable X
load('Y.mat'); % Contains variable Y
load('Z.mat'); % Contains variable Z

figure;
hold on;

% Plot Bone as a Cuboid
plotBone();

% Plot Tumour (Convex Hull and Unique Surface Points)
VerticesUnique = plotTumour(X, Y, Z);

% Compute and plot the bounding box for the tumour.
[center, dims] = plotTumourBoundingBox(VerticesUnique);






%% Cutting Tool paths

% Define parameters
tolerance = 5;         % Offset (in mm) for the cutting path and deepest z computation
numLaserSteps = 20;    % Number of steps for laser vertical movement
numVerticalSteps = 20; % Number of steps for cutting tool vertical movement
deltaZ = 5;            % Vertical increment used to compute the starting point

% Precompute the starting point
startPt = calculateStartingPoint(VerticesUnique, tolerance, deltaZ);

% Generate and display trajectories; the coordinate data (with key messages)
% is stored in the workspace as "laserPath" and "cuttingToolPath".
generateLaserTrajectory(VerticesUnique, tolerance, numLaserSteps, startPt);
generateCuttingTrajectory(VerticesUnique, tolerance, numVerticalSteps, startPt);




%%










% Final Plot Adjustments
axis equal;
xlim([0 50]);
ylim([0 50]);
zlim([-30 20]);
xlabel('x (mm)');
ylabel('y (mm)');
zlabel('z (mm)');
grid on;
view(3);
legend('Location','best');
title('Tumour and Bone Visualization with Bounding Box and Cutting Tool Path');

hold off;
