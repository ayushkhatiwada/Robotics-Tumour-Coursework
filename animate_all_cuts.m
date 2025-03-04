%% Load Tumour Data to Visualize Tumour in Animation

% Load the tumour data (X, Y, Z coordinates)
load('X.mat'); % X coordinates of tumour surface
load('Y.mat'); % Y coordinates of tumour surface
load('Z.mat'); % Z coordinates of tumour surface

% Compute the convex hull indices with simplification.
[k2, ~] = convhull(X, Y, Z, 'Simplify', true);

% Extract vertices used by the convex hull.
Vertices = [X(k2(:,1)), Y(k2(:,1)), Z(k2(:,1));
            X(k2(:,2)), Y(k2(:,2)), Z(k2(:,2));
            X(k2(:,3)), Y(k2(:,3)), Z(k2(:,3))];

% Remove duplicate vertices.
VerticesUnique = unique(Vertices, 'rows');


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


%% Animate All Cuts

% delay between animation steps in seconds
delayBetweenCuts = 0.03;
% Animate the cuts
animateCuttingPaths(laserBeamPath1, cuttingToolPath1, laserBeamPath2, cuttingToolPath2, VerticesUnique, delayBetweenCuts);
