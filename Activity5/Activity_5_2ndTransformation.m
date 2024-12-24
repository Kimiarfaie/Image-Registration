% Class exercise 5. Transformation 2 - Rigid Transform
clear all
clc
%% Step 1. Execute your Activity 4 code, and get the original and registered images with the best solution you have been able to find
%im_orig=imread('coin.png'); 
im_orig=imread('catt_matlab.jpg'); 
im_orig = rgb2gray(im_orig); % additional
rc = imref2d(size(im_orig));
CPs_Matlab_orig_det = detectSIFTFeatures(im_orig);
[CPs_Matlab_orig_feat,  CPs_Matlab_orig_ext]  = extractFeatures(im_orig, CPs_Matlab_orig_det);
T2 = ([cosd(10) sind(10) 0; -sind(10) cosd(10) 0; 10 10 1]);
Tform_rigid = affine2d(T2);
[im_rigid, Rri] = imwarp(im_orig, Tform_rigid);
CPs_Matlab_t_det2= detectSIFTFeatures(im_rigid);
[CPs_Matlab_t_feat2,  CPs_Matlab_t_ext2]  = extractFeatures(im_rigid,  CPs_Matlab_t_det2);
[indexPairs,~] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat2,'Unique',true,'MaxRatio',0.5);

matched_set_ref=CPs_Matlab_orig_ext(indexPairs(:,1));
matched_set_sen=CPs_Matlab_t_ext2(indexPairs(:,2));

tform_est2 = estgeotform2d(matched_set_sen, matched_set_ref, "affine");

outputView = imref2d(size(im_orig));
im_reg2  = imwarp(im_rigid, tform_est2, OutputView = outputView);
%% Step 2. Implement an intensity-based quality metric (RMSE)

% It might be convenient to stack the image data before the computation of the vector of pixel-by-pixel differences

pix_orig=im_orig(:);
pix_reg=im_reg2(:);

%COMPLETE CODE HERE TO COMPUTE THE RMSE ACCORDING TO THE EQUATION IN SLIDE 58
RMSE_SIFT = sqrt((1/(-1+length(pix_orig)))*sum((pix_orig-pix_reg).^2));

%Compute the relative value, assuming an 8-bit image (maximum value of RMSE = 255)
RMSE_rel_SIFT=RMSE_SIFT/255;


%% Step 3. Implement a CP-location-based quality metric. 

% 3.1. Extract a new CP in the original and registered images, using a different feature - FAST

CPs_eval_ref = detectSURFFeatures(im_orig);
CPs_eval_reg = detectSURFFeatures(im_reg2);

[CPs_eval_ref_feat,  CPs_eval_ref_ext]  = extractFeatures(im_orig,  CPs_eval_ref);
[CPs_eval_reg_feat,  CPs_eval_reg_ext]  = extractFeatures(im_reg2,  CPs_eval_reg);

%3.2. Match both and show the results

[indexPairs,matchmetric] = matchFeatures(CPs_eval_ref_feat, CPs_eval_reg_feat, 'Unique',true, 'MaxRatio',0.5);
matched_set_ref=CPs_eval_ref_ext(indexPairs(:,1));
matched_set_reg=CPs_eval_reg_ext(indexPairs(:,2));

% Show the results Using showMatchedFeatures function
figure, ax=axes;
showMatchedFeatures(im_orig, im_reg2, matched_set_ref, matched_set_reg,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points Ref','Matched points Registered');

% Show the results using a plot of CP locations with different symbols
figure, ax=axes;
imshow(im_orig)
hold on
plot(matched_set_ref.Location(:,1), matched_set_ref.Location(:,2), 'ro');
plot(matched_set_reg.Location(:,1),matched_set_reg.Location(:,2),'bx');
legend(ax, ' Original', 'Registered');
title(ax, "Original and Registered CP locations")


% 3.3. Refine previous steps if you don't get a full set of correct matches

% 3.4.1 Compute the Euclidean average distance between matched CPsdiff = matched_set_ref.Location - matched_set_reg.Location;

diff = matched_set_ref.Location-matched_set_reg.Location;
CP_Loc_error = (1/(size(matched_set_ref,1)-1))*sum(sqrt((diff(:,1).^2+diff(:,2).^2)));

% 3.4.2 Compute the Mean residual between matched CPs
diffx = matched_set_ref.Location(:,1)-matched_set_reg.Location(:,1);
diffy = matched_set_ref.Location(:,2)-matched_set_reg.Location(:,2);
CP_Loc_error_residualx = (1/(size(matched_set_ref,1)-1))*sum(abs((diffx.^2+diffx.^2)));
CP_Loc_error_residualy = (1/(size(matched_set_ref,1)-1))*sum(abs((diffy.^2+diffy.^2)));


%Maximum displacement in the horizontal and vertical directions
Max_horizontal_displacement = max(abs(diff(:, 1)));
Max_vertical_displacement = max(abs(diff(:, 2)));

%% Analysis

% Relative RMSE: 0.0207
% With normalization, the relative RMSE of 0.0207, which is quite low implies that the pixel intensities between the original and registered images are very close.

% Absolute RMSE: 5.286
%This metric represents the average pixel-level intensity error between the original and registered images. The value is quite low on an 8-bit scale, confirming a strong similarity.

%CP_loc_Error (Euclidean Distance): 0.1832
% This is the mean Euclidean distance between corresponding control points in the original and registered images. 
% A value of 0.1832 indicates that the registration has aligned the control points quite well, as this is a relatively small distance.

%CP_Loc_error_residualx: 0.0773
% A value of 0.0773 implies a negligible horizontal shift, demonstrating effective alignment.

%CP_Loc_error_residualy: 0.1090
% Although larger than the horizontal residual, 0.1090 still indicates a relatively small error vertically.

%Maximum Horizontal Displacement: 1.5986
%A maximum horizontal displacement of 1.5986 is relatively small, indicating that the registration has effectively aligned the control points horizontally. This minimal shift demonstrates good registration accuracy.

%Maximum Vertical Displacement: 1.6810
% A vertical displacement of 1.6810 is also quite small, similar to the horizontal displacement. 
% This shows that the registration aligns the points well in the vertical direction.

%% Print variables:

% Print statements for RMSE and relative RMSE values
fprintf('RMSE_SIFT: %f\n', RMSE_SIFT);
fprintf('Relative RMSE (SIFT): %f\n\n', RMSE_rel_SIFT);

% Print statements for CP location errors
fprintf('CP Location Error: %f\n', CP_Loc_error);
fprintf('CP Location Error Residual X: %f\n', CP_Loc_error_residualx);
fprintf('CP Location Error Residual Y: %f\n\n', CP_Loc_error_residualy);

% Print statements for maximum displacements
fprintf('Maximum Horizontal Displacement: %f\n', Max_horizontal_displacement);
fprintf('Maximum Vertical Displacement: %f\n', Max_vertical_displacement);
