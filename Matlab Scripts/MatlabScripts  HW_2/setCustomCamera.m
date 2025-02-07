%
% Script to recover the parameters to define a custom camera in Unity
%
clear;
close all;
addpath('../Utils');

% Picker for the XMP file
[file,location] = uigetfile('*.xmp','Select .xmp file');
xmpFilePath = fullfile(location, file);

disp(['File main: ', xmpFilePath]);

% Get calibration data

[Iw,Ih,fx,fy,cx,cy,R,t] = getParamsFromXMP(xmpFilePath);

% Sensor Size: here we refer to a generic sensor with an arbitrary SensorX
% for instance if it is not specified a typical value is SensorX=35
SensorX=35;

%Compute focal length in mm:
fmm=fx*(SensorX/Iw);

%Now recover the SensorY:
% we reverse the following equation: fmm=fy*(SensorY/Ih);
SensorY=fmm*(Ih/fy);

% Compute lens shifts:
ls_x=-(cx-(Iw/2))/Iw;
ls_y=(cy-(Ih/2))/Ih;

%Value to set in the Unity Inspector under 'Physical Camera'
disp(['Focal Length in mm: ' num2str(fmm)]);
disp(['Sensor Size x: ' num2str(SensorX)]);
disp(['Sensor Size y: ' num2str(SensorY)]);
disp(['Lens Shift x: ' num2str(ls_x)]);
disp(['Lens Shift y: ' num2str(ls_y)]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Extrinsic parameters from xmp file:
%
%Input: Rotation and translation on Zephyr ref (from world to camera):


%Mirror y-axis:
Sy=[1 0 0; 0 -1 0; 0 0 1];
%Invert Y-axis with Z-axis
YZ=[1 0 0; 0 0 1; 0 1 0];

%Compute the Rotation and Translation in the Unity ref (from camera to
%world)



R_u=YZ*(Sy*R)';
T_u=YZ*(-(Sy*R)'*(Sy*t));



% Complicated steps to estimate Euler angles withing Unity frame:
% Unity rotate around Z fist, then around X and then around Y:
R_eun=[R_u(:,3) R_u(:,1) R_u(:,2)];
R_eun1=[R_eun(3,:); R_eun(1,:); R_eun(2,:)];
eu_V=ieul(R_eun1);
euu_V=rad2deg(eu_V);
euu_VU=[euu_V(2);euu_V(3); euu_V(1)];

disp(['Position X Y Z: ' num2str(T_u')]);
disp(['Rotation X Y Z: ' num2str(euu_VU')]);

saveResultToJson(Iw,Ih,fmm,SensorX,SensorY,ls_x,ls_y,T_u,euu_VU);


