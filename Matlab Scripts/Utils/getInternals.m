function K = getInternals(imgPath)
image = imread(imgPath);

info = imfinfo(imgPath);

[H, W, C]= size(image);

SensorW=35;
%SensorW=22.6695;% This is from xmp file (when available, otherwise 
%the header file encodes a value of focal lenght in mm making the
%assumption that sensor size is 35mm (in that case uncomment the following
%line and comment the next:
%Fmm=info.DigitalCamera.FocalLengthIn35mmFilm;
Fmm=info.DigitalCamera.FocalLength;

fp=((Fmm*W)/SensorW)*10;

u_0=W/2;
v_0=H/2; 

K=[fp 0 u_0; 0 fp v_0; 0 0 1];
end