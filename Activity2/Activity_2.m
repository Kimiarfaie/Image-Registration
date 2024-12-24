% Class exercise 2. BLANK CODE
clc
clear all
close all
%% Step 1. Implemented feature extraction. 
% a) Read image and show it
im_orig=imread('coin.png'); %change to your own image here if you did not use the coin
rc = imref2d(size(im_orig));
figure, imshow(im_orig,rc),title('Original image');

%% Step 2. Extract features from the original image with a Matlab implemented feature

%2.1. Feature detection
CPs_Matlab_orig_det = detectSIFTFeatures(im_orig);

%2.2. Feature extraction
[CPs_Matlab_orig_feat,  CPs_Matlab_orig_ext]  = extractFeatures(im_orig, CPs_Matlab_orig_det);

%2.3. You might want to reduce the number of CPs to around 50, if you have more than this number

target_n = 60; 
CPs_Matlab_orig_ext_str = CPs_Matlab_orig_ext.selectStrongest(target_n);

%2.4. Plot extracted CPs along with the coin image

figure, imshow(im_orig,rc),title('Original image with CP extracted by Matlab implemented feature')
hold on
plot(CPs_Matlab_orig_ext_str.Location(:,1),CPs_Matlab_orig_ext_str.Location(:,2),'bx','LineWidth',2); 


%% Step 3. Repeat the process with the transformed image from activity 1

% 3.1. Define the transform (COPY FROM ACTIVITY 1):

tform = affine2d([1 0 0; -0.3 1 0; 0 0 1]);

%3.2) Apply YOUR TRANSFORM

[im_aff,Rtr] = imwarp(im_orig, tform); %if I use Rtr in the plot, then the locations aren't correct%
rt = imref2d(size(im_aff));

% 3.3. Repeat the process of extraction with the Matlab feature you have selected.

CPs_Matlab_t_det= detectSIFTFeatures(im_aff);
[CPs_Matlab_t_feat,  CPs_Matlab_t_ext]  = extractFeatures(im_aff,  CPs_Matlab_t_det);

% Select the strongest CPs (within availability)

CPs_Matlab_t_ext_str=CPs_Matlab_t_ext.selectStrongest(target_n);

% Show the final selected set

figure, imshow(im_aff,rt),title('Transformed image with CP extracted by Matlab implemented feature')
hold on
plot(CPs_Matlab_t_ext_str.Location(:,1),CPs_Matlab_t_ext_str.Location(:,2),'gx','LineWidth',2); 

%% 4. Comparison between the two CP distributions

figure, subplot(1,2,1); 
imshow(im_orig,rc)
hold on
plot(CPs_Matlab_orig_ext_str.Location(:,1),CPs_Matlab_orig_ext_str.Location(:,2),'bx','LineWidth',2);
title('Original CP set');
subplot(1,2,2);
imshow(im_aff,rt);
hold on, plot(CPs_Matlab_t_ext_str.Location(:,1),CPs_Matlab_t_ext_str.Location(:,2),'gx','LineWidth',2);
title('CP set extracted after transform');

% Think about how you would graphically evaluate the degree of overlapping in the two
% CP distributions 

%%
% Repeating everything for the second transformation SURF, FAST,
% ORB, 

%Original Image
CPs_Matlab_orig_det = detectBRISKFeatures(im_orig);

%2.2. Feature extraction
[CPs_Matlab_orig_feat,  CPs_Matlab_orig_ext]  = extractFeatures(im_orig, CPs_Matlab_orig_det);

%2.3. You might want to reduce the number of CPs to around 50, if you have more than this number

target_n = 100; 
CPs_Matlab_orig_ext_str = CPs_Matlab_orig_ext.selectStrongest(target_n);

%2.4. Plot extracted CPs along with the coin image

figure, imshow(im_orig,rc),title('Original image with CP extracted by Matlab implemented feature')
hold on
plot(CPs_Matlab_orig_ext_str.Location(:,1),CPs_Matlab_orig_ext_str.Location(:,2),'bx','LineWidth',2); 


%Transformed

T2 = ([cosd(10) sind(10) 0; -sind(10) cosd(10) 0; 10 10 1]);
Tform_rigid = affine2d(T2);
[im_rigid, Rri] = imwarp(im_orig, Tform_rigid);

% Feature detection and extraction

CPs_Matlab_t_det2= detectBRISKFeatures(im_rigid);
[CPs_Matlab_t_feat2,  CPs_Matlab_t_ext2]  = extractFeatures(im_rigid,  CPs_Matlab_t_det2);

% Select the strongest CPs (within availability)

CPs_Matlab_t_ext_str2=CPs_Matlab_t_ext2.selectStrongest(target_n);

% Show the final selected set

figure, imshow(im_rigid,Rri),title('Transformed image with CP extracted by Matlab implemented feature')
hold on
plot(CPs_Matlab_t_ext_str2.Location(:,1),CPs_Matlab_t_ext_str2.Location(:,2),'gx','LineWidth',2); 
