load X.mat
load Y.mat
load Z.mat
    
% Plot Tumour 
% https://uk.mathworks.com/help/matlab/ref/convhull.html
[k2,av2] = convhull(X,Y,Z,'Simplify',true);
trisurf(k2,X,Y,Z,'FaceColor','cyan')
axis equal
xlim([0 50])
ylim([0 50])
zlim([-30 20])
xlabel('x')
ylabel('y')
zlabel('z')


% Vertices for Students' Algorithm %

% Extracts all unique tumour verticies
% Collects all convex hull vertices
% Uses unique() to remove duplicates, keeping only unique tumour
% surface points.
Vertices = [X(k2(:,1)),Y(k2(:,1)),Z(k2(:,1))];
Vertices = [Vertices; X(k2(:,2)),Y(k2(:,2)),Z(k2(:,2))];
Vertices = [Vertices; X(k2(:,3)),Y(k2(:,3)),Z(k2(:,3))];
VerticesUnique = unique(Vertices,'rows');


hold on
scatter3(VerticesUnique(:,1),VerticesUnique(:,2),VerticesUnique(:,3),'r')
