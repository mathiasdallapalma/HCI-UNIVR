clear all
close all
clc

% Load correspondences and parameters:
load('imgInfo.mat')

% Image:
img = imread('cav.jpg');

% 2D-3D correspondences and intrinsics:
p2D = imgInfo.punti2DImg;
p3D = imgInfo.punti3DImg;
K = imgInfo.K;

% 3D points:
figure(1)
scatter3(p3D(:,1),p3D(:,2),p3D(:,3),5,'c');
axis equal

%
% Project 3D points using the available extrinsics and intrinsics:
figure(2)
imshow(img);
hold on;
plot(p2D(:,1), p2D(:,2),'r.');
P=K*[imgInfo.R imgInfo.T];
[u,v] = proj(P,p3D);
plot(u,v,'go');

% 3D points:
figure(2)
scatter3(p3D(:,1),p3D(:,2),p3D(:,3),5,'c');
axis equal

% Exterior orientation
% Subsampling,
% note that we use 'absolute' with scale, then  the scale factor is not
% important since the homogeneous coordinates are converted to cartesian coordinates.
% 
[G,s] = exterior_fiore(K,p3D(1:100,:)',p2D(1:100,:)');
%
% Projection using the estimated extrinsics:
figure(3);
imshow(img);
hold on;
plot(p2D(:,1), p2D(:,2),'r.');
P1=K*G;
[u1,v1] = proj(P1,p3D);
plot(u1,v1,'bo');
%

% Comparison between the grount truth and the estimated matrices:
% 
[imgInfo.R imgInfo.T G]

