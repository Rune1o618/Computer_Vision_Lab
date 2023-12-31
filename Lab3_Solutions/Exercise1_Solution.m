% Exercise 1
clear;  clc;
% Define a 2-by-2 square centered at (xc,yc) = (4,4). Note that the
% position of the upper right corner of the square is dublicated to
% ensure that the square is closed when plotting it.
xc = 4;
yc = 4;
square = [ xc+1 xc+1 xc-1 xc-1 xc+1;
           yc+1 yc-1 yc-1 yc+1 yc+1];
figure(1)
plot(square(1,:),square(2,:),'-',xc,yc,'.')
legend('Square','Center of square','Location','SouthEast')
xlabel('X')
ylabel('Y')
axis([-2 6 -2 6])
axis equal

% Convert square to homogeneous coordinates
square_homo = [ square;
                ones(1,5) ];

% Step 1:
% Define a 3-by-3 transformation matrix (A) that rotates the square by 45
% degrees (counter-clockwise) around its center point (xc,yc).
         
% A = ???
% Only rotation but shifting the coordinate system
theta = pi/4;
T1 = [ 1 0 xc;
       0 1 yc;
       0 0 1];
T2 = [ 1 0 -xc;
       0 1 -yc;
       0 0 1];
R = [cos(theta) -sin(theta) 0;
     sin(theta)  cos(theta) 0;
         0           0      1];

A = T1*R*T2;

% Verify the above matrix using Least Squares Regression
% mapping of the points
% [3,3] --> [4,4-sqrt(2)]
% [5,3] --> [4+sqrt(2),4]
% [5,5] --> [4,4+sqrt(2)]
% [3,5] --> [4-sqrt(2),4]
a = sqrt(2);
tmp_rotated = [ xc   xc+a xc   xc-a xc;
                yc+a yc   yc-a yc   yc+a;
                ones(1,5)];
A2 = tmp_rotated * pinv(square_homo);

square_homo_rotated = A*square_homo;
figure(1)
hold on
plot(square_homo_rotated(1,:),square_homo_rotated(2,:),'r-')
hold off
legend('Square','Center of square','Square rotated 45 degrees','Location','SouthEast')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Transformations in 3D
xc = 4;
yc = 4;
zc = 3;
cube = [ xc+1 xc+1 xc-1 xc-1 xc+1 xc+1 xc+1 xc-1 xc-1 xc+1 xc+1 xc+1 xc-1 xc-1 xc-1 xc-1;
           yc+1 yc-1 yc-1 yc+1 yc+1 yc+1 yc-1 yc-1 yc+1 yc+1 yc-1 yc-1 yc-1 yc-1 yc+1 yc+1;
           zc-1 zc-1 zc-1 zc-1 zc-1 zc+1 zc+1 zc+1 zc+1 zc+1 zc+1 zc-1 zc-1 zc+1 zc+1 zc-1];
fig = figure()
plot3(cube(1,:),cube(2,:),cube(3,:),'-',xc,yc,zc,'.')
legend('Cube','Center of cube','Location','SouthEast')
xlabel('X')
ylabel('Y')
zlabel('Z')
axis equal
axis([-2 6 -2 6 -2 6])
grid on

% Convert cube to homogeneous coordinates
cube_homo = [ cube;
                ones(1,size(cube,2)) ];
             
% A = ???

% Define the translation matrices first
T1 = [ 1 0 0 xc;
       0 1 0 yc;
       0 0 1 zc;
       0 0 0 1];
T2 = [ 1 0 0 -xc;
       0 1 0 -yc;
       0 0 1 -zc;
       0 0 0 1];
% z --> 70 degrees
theta = (70/180)*pi;
Rz = [cos(theta) -sin(theta) 0 0;
      sin(theta)  cos(theta) 0 0;
           0          0      1 0;
           0          0      0 1];

% y --> 45 degrees
phi = pi / 4;
Ry = [cos(phi) 0 sin(phi)  0;
         0     1    0      0;
     -sin(phi) 0 cos(phi)  0
         0     0    0      1];

% x --> 20 degrees
psi = (20/180)*pi;
Rx = [1    0         0      0;
      0 cos(psi) -sin(psi)  0;
      0 sin(psi)  cos(psi)  0;
      0    0         0      1];

A = (T1*Rz*T2) * (T1*Ry*T2) * (T1*Rx*T2);

cube_homo_rotated = A*cube_homo;
figure(fig)
hold on
plot3(cube_homo_rotated(1,:),cube_homo_rotated(2,:),cube_homo_rotated(3,:),'r-')
hold off
legend('Cube','Center of cube','Cube rotated 45 degrees','Location','SouthEast')
