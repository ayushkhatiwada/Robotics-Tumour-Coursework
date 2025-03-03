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
animateCuttingPaths(laserBeamPath1, cuttingToolPath1, laserBeamPath2, cuttingToolPath2, VerticesUnique);
