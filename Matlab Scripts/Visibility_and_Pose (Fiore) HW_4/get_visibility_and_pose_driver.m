%
% Extract visible 3D points in an image and compute the camera pose using
% Fiore's method
%
%
clear;
close all;
addpath('../Utils');
%
% Ingredients:
% The full cloud points exported from Zephyr 
% the ref image 
% the point of the full cloud point that are visible to the ref image:
% this information is contained in the file 'Visibility.txt' exported from
% Zephyr. This file contains the visibility of all views. Here we manually
% extract only the visible points on the given image
%

%Inputs
[file,location]   = uigetfile('*.ply','Select full cloud point file');
zephyrPlyFile  = fullfile(location, file);
[file,location]  = uigetfile('*.txt','Select Visibility file');
visibilityPointFile = fullfile(location, file); 
[file,location]  = uigetfile('*.xmp','Select xmp file');
xmpFile = fullfile(location, file);
[file,location]  = uigetfile('*.jpg','Select image file');
imgFile = fullfile(location, file);

Img=imread(imgFile);
         
% Extract 2D and 3D from ref image:
[p2D, p3D] = cloud_get_points(zephyrPlyFile,visibilityPointFile);
%
%Plot cloud point:
figure(1);
plot3(p3D(:,1),p3D(:,2),p3D(:,3),'r.'); 
grid on; 
axis equal

% Read camera parameters from xmp file:s
[Iw,Ih,fx,fy,cx,cy,R,T] = getParamsFromXMP(xmpFile);

K=[fx,    0,        cx;
    0,    fy,       cy;
    0,    0,        1];



%
%Project 3D points to image:
figure(2);
imshow(Img);
hold on;
plot(p2D(:,1),p2D(:,2), 'r.');

% Define the PPM and reproject 3D points:
P=K*[R T];
[u,v] = proj(P,p3D);
plot(u,v, 'bo');

%Now we avoid the use of xmp data:
% Estimate the Intrinsics from header file 
KK = getInternals(imgFile);



%Estimate pose using Fiore's method:
% Update the path accordingly:
addpath '../EsempioFiore';
[G,s] = exterior_fiore(K,p3D(1:100,:)',p2D(1:100,:)');



% figure(3);
imshow(Img);
hold on;
plot(p2D(:,1), p2D(:,2),'r.');
Compose the PPM combining the intrinsics and computed extrinsics:
P1=K*G;
[u1,v1] = proj(P1,p3D);
plot(u1,v1,'bo');

%
% Comparison between estimated data and ground truth

disp('Ground truth:');
disp(num2str([R T K]));
disp('Calculated:');
disp(num2str([G KK]));

saveResultToXMP(xmpFile,G);

% 
disp('Now we can use the matlab script to convert these intrinsics and extrinsics parameters in Unity');
