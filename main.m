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

% Create and plot outline of tumour in (x, y) axis
tolerance = 0;      % Outward offset distance
colour = 'b';
lineStyle = ':';
plotTumourOutline(VerticesUnique, tolerance, colour, lineStyle);

% Create and plot the cutting tool path (extruded side walls).
tolerance = 5;       % Outward offset distance
colour = 'm';
plotCuttingToolPath(VerticesUnique, tolerance, colour);

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
