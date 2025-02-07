%
% Compute matching and pose
% 
clear;
close all;
addpath('../Utils');

%Inputs
[file,location]   = uigetfile('*.ply','Select full cloud point file');
zephyrPlyFile  = fullfile(location, file);

[file,location]  = uigetfile('*.jpg','Select target image file');
TgImgFile = fullfile(location, file);

[reference_image,location]  = uigetfile('*.jpg','Select reference image file');
RefImgFile = fullfile(location, reference_image);

[file,location]  = uigetfile('*.txt','Select visibility file');
visibilityPointFile = fullfile(location, file);

RefImg=imread(RefImgFile);

% Ref points:
[p2D, p3D] = cloud_get_points(zephyrPlyFile,visibilityPointFile);


%
TgImg=imread(TgImgFile);

%Visualize intermediate steps?
image_verbose=true;

if (image_verbose)
    disp('Show images');
    figure(1)
    imshow(TgImg);
    figure(2)
    imshow(RefImg);
end

% Here we compute the 2D-2D matching between the target and ref images
% We use SIFT matching but any other method can be used here:
peak_thresh=8;
best_frac_match=1; 
[matches, f_tg, f_ref]= mixed_sift_matching(TgImg,RefImg, peak_thresh, best_frac_match);
%

% Compute 2D 3D matching:
% Select ref 2D points on RefImg 
%
disp('compute 2D-3D correspondances')
[sel, dist] = dsearchn(p2D,f_ref(1:2,matches(2,:))');
%
if(image_verbose)
    figure(3)
    imshow(RefImg);
    hold on;
    plot(f_ref(1,matches(2,:)), f_ref(2,matches(2,:)), 'bo');
    plot(p2D(sel,1), p2D(sel,2), 'ro');
end
%
p2D_step1=p2D(sel,:);
p3D_step1=p3D(sel,:);
f_ref_step1=f_ref(:,matches(2,:));
f_tg_step1=f_tg(:,matches(1,:));

%Keep only close points:
threshold = 4; 
%
indsel=find(dist<threshold);
fprintf('n° of mathced points: %d/n', length(matches));
fprintf('n° of points that are closer than threshold: %d\n', length(indsel));


%
f_ref_step2=f_ref_step1(:, indsel);
f_tg_step2=f_tg_step1(:, indsel);
p2D_step2=p2D_step1(indsel,:);
p3D_step2=p3D_step1(indsel,:);


if(image_verbose)
    for i=1:length(f_tg_step2)
        figure(4);
        clf ;
        imagesc(cat(2, TgImg, RefImg)) ;
        vl_plotframe(f_tg_step2(:,i)) ;
        f_ref_step2_move=f_ref_step2;
        f_ref_step2_move(1,:) = f_ref_step2_move(1,:) + size(TgImg,2) ;
        vl_plotframe(f_ref_step2_move(:,i)) ;
        axis image off ;
        hold off;
        disp(i)
        pause(2);
    end
end

%Now compute pose:
%
disp('compute pose estimation');
%estimate the Intrinsics from header file 
KK = getInternals(TgImgFile);

p3D_ref=p3D_step2;
p2D_tg=f_tg_step2(1:2,:)';

%Estimate pose using Fiore's method:
% Update the path accordingly:
addpath('../EsempioFiore');
[G,s] = exterior_fiore(KK,p3D_ref',p2D_tg');
if(image_verbose)
    figure(5);
    imshow(TgImg);
    hold on;
    plot(p2D_tg(:,1), p2D_tg(:,2),'r.');
end
% Compose the PPM combining the intrinsics and computed extrinsics:
P1=KK*G;
[u1,v1] = proj(P1,p3D_ref);
plot(u1,v1,'bo');
%
disp('The estimated pose is:')
disp(G);

% Compute the parameters for custom camera in Unity:
[Ih,Iw,drop]=size(TgImg);
[fmm, SensorX, SensorY, ls_x, ls_y, euu_VU, T_u ] = set_unity_cam (Iw, Ih, KK, G(1:3,1:3), G(1:3,4));

fx=KK(1,1);
fy=KK(2,2);
cx=KK(1,3);
cy=KK(2,3);

out_path = './out.txt'
saveResultToNewXMP(out_path,Iw,Ih,fmm,cx,cy,fx,fy,G,length(matches),length(indsel),reference_image_name);
   

