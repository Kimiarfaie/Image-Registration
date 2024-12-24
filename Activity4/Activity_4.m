% Class exercise 4
clc;
clear all;
close all;

%% Step 1. Execute your Activity 3 code, and get the matched CP sets for the reference and sensed images using SIFT
im_orig = imread('coin.png'); 
rc = imref2d(size(im_orig));
CPs_Matlab_orig_det = detectSIFTFeatures(im_orig);
[CPs_Matlab_orig_feat, CPs_Matlab_orig_ext] = extractFeatures(im_orig, CPs_Matlab_orig_det);

tform = affine2d([1 0 0; -0.3 1 0; 0 0 1]);
[im_t, Rtr] = imwarp(im_orig, tform);
rt = imref2d(size(im_t));

CPs_Matlab_t_det = detectSIFTFeatures(im_t);
[CPs_Matlab_t_feat, CPs_Matlab_t_ext] = extractFeatures(im_t, CPs_Matlab_t_det);

[indexPairs, matchmetric] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat, 'Unique', true, 'MaxRatio', 0.4);
matched_set_ref = CPs_Matlab_orig_ext(indexPairs(:,1));
matched_set_sen = CPs_Matlab_t_ext(indexPairs(:,2));

%% Step 2. Estimate the transform using both CP sets and the function estimateGeometricTransform
% Change the transform type according to the problem tackled
tform_est = estgeotform2d(matched_set_sen, matched_set_ref, "affine");

%% Step 3. Register the image with the estimated transform from Step 1
% Set the original image frame for visualization
outputView = imref2d(size(im_orig));
im_reg = imwarp(im_t, tform_est, 'OutputView', outputView);

%% Step 4. Show the overlap plot of the original and registered images, and visually evaluate the result
figure, imshowpair(im_orig, im_reg, "falsecolor");
title("Overlap of Original and Registered Images Using SIFT and Shearing Transformation")

% Save figure
set(gcf, 'Position', [100, 100, 800, 600]);
print('shear_registration','-dpng','-r300');
%% Step 5. If the result does not look satisfactory, try one or several of the following approaches:

% The results look satisfactory

%% 
% Repeat everything for the Second Transformation using SIFT

im_orig = imread('coin.png'); 
rc = imref2d(size(im_orig));
CPs_Matlab_orig_det = detectSIFTFeatures(im_orig);
[CPs_Matlab_orig_feat, CPs_Matlab_orig_ext] = extractFeatures(im_orig, CPs_Matlab_orig_det);

T2 = ([cosd(10) sind(10) 0; -sind(10) cosd(10) 0; 10 10 1]);
Tform_rigid = affine2d(T2);
[im_rigid, Rri] = imwarp(im_orig, Tform_rigid);

CPs_Matlab_t_det2 = detectSIFTFeatures(im_rigid);
[CPs_Matlab_t_feat2, CPs_Matlab_t_ext2] = extractFeatures(im_rigid, CPs_Matlab_t_det2);

[indexPairs,matchmetric] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat2,'Unique',true,'MaxRatio',0.4);

matched_set_ref = CPs_Matlab_orig_ext(indexPairs(:,1));
matched_set_sen = CPs_Matlab_t_ext2(indexPairs(:,2));

tform_est2 = estgeotform2d(matched_set_sen, matched_set_ref, "affine");

outputView = imref2d(size(im_orig));
im_reg2 = imwarp(im_rigid, tform_est2, 'OutputView', outputView);

figure, imshowpair(im_orig, im_reg2, "falsecolor");
title("Overlap of Original and Registered Images Using SIFT and Rigid Transformation")

% Save figure
set(gcf, 'Position', [100, 100, 800, 600]);
print('rigid_registration','-dpng','-r300');
