% Class exercise 5. - Shear Transform
clear all 
clc
%% Step 1. Execute your Activity 4 code, and get the original and registered images with the best solution you have been able to find
%im_orig=imread('coin.png'); 
im_orig=imread('catt_matlab.jpg'); 
im_orig = rgb2gray(im_orig); % additional
rc = imref2d(size(im_orig));
CPs_Matlab_orig_det = detectSIFTFeatures(im_orig);
[CPs_Matlab_orig_feat,  CPs_Matlab_orig_ext]  = extractFeatures(im_orig, CPs_Matlab_orig_det);
tform = affine2d([1 0 0; -0.3 1 0; 0 0 1]);
[im_t,Rtr] = imwarp(im_orig, tform);
rt = imref2d(size(im_t));
CPs_Matlab_t_det= detectSIFTFeatures(im_t);
[CPs_Matlab_t_feat,  CPs_Matlab_t_ext]  = extractFeatures(im_t,  CPs_Matlab_t_det);
[indexPairs, ~] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat,'Unique',true,'MaxRatio',0.4);
matched_set_ref = CPs_Matlab_orig_ext(indexPairs(:,1));
matched_set_sen = CPs_Matlab_t_ext(indexPairs(:,2));
tform_est = estimateGeometricTransform2D(matched_set_sen, matched_set_ref, "affine");
outputView = imref2d(size(im_orig));
im_reg  = imwarp(im_t, tform_est, OutputView = outputView);
%% Step 2. Implement an intensity-based quality metric (RMSE) for SIFT

% It might be convenient to stack the image data before the computation of the vector of pixel-by-pixel differences

pix_orig=im_orig(:);
pix_reg=im_reg(:);

%COMPLETE CODE HERE TO COMPUTE THE RMSE ACCORDING TO THE EQUATION IN SLIDE 58
RMSE_SIFT = sqrt((1/(-1+length(pix_orig)))*sum((pix_orig-pix_reg).^2));

%Compute the relative value, assuming an 8-bit image (maximum value of RMSE = 255)
RMSE_rel_SIFT=RMSE_SIFT/255;


%% Step 3. Implement a CP-location-based quality metric - Using SURF

% 3.1. Extract anew CP in the original and registered images, using a different feature than the one you used for solving the registration problem

CPs_eval_ref = detectSURFFeatures(im_orig);
CPs_eval_reg = detectSURFFeatures(im_reg);

[CPs_eval_ref_feat,  CPs_eval_ref_ext]  = extractFeatures(im_orig,  CPs_eval_ref);
[CPs_eval_reg_feat,  CPs_eval_reg_ext]  = extractFeatures(im_reg,  CPs_eval_reg);

%3.2. Match both and show the results

[indexPairs,matchmetric] = matchFeatures(CPs_eval_ref_feat, CPs_eval_reg_feat, 'Unique',true);
matched_set_ref=CPs_eval_ref_ext(indexPairs(:,1));
matched_set_reg=CPs_eval_reg_ext(indexPairs(:,2));

% Show the results Using showMatchedFeatures function
figure, ax=axes;
showMatchedFeatures(im_orig, im_reg, matched_set_ref, matched_set_reg,'montage','Parent',ax);
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

% 3.4.1 Compute the Euclidean average distance between matched CPs;
diff = matched_set_ref.Location-matched_set_reg.Location;
CP_Loc_error_euclidean = (1/(size(matched_set_ref,1)-1))*sum(sqrt((diff(:,1).^2+diff(:,2).^2)));

% 3.4.2 Compute the Mean residual between matched CPs
diffx = matched_set_ref.Location(:,1)-matched_set_reg.Location(:,1);
diffy = matched_set_ref.Location(:,2)-matched_set_reg.Location(:,2);
CP_Loc_error_residualx = (1/(size(matched_set_ref,1)-1))*sum(abs((diffx.^2+diffx.^2)));
CP_Loc_error_residualy = (1/(size(matched_set_ref,1)-1))*sum(abs((diffy.^2+diffy.^2)));

% 
%Maximum displacement in the horizontal and vertical directions
Max_horizontal_displacement = max(abs(diff(:, 1)));
Max_vertical_displacement = max(abs(diff(:, 2)));

%% Analysis

% Using a different feature detection method for evaluating the quality
% of the registration is meant to provide a more comprehensive assessment. 
% Using a different feature detection method ensures that the quality evaluation is 
% not overly influenced by the characteristics of the feature detector that was
% otiginally used for registration.

% Different features like SIFT, SURF, ORB, or FAST focus on different image 
% characteristics. Evaluating with a different method may reveal issues that 
% the original registration process did not detect.

% This appraoch demonstrates the reliability of our registration method using 
% another feature extraction and matching approach.

%% RMSE
% The Root Mean Square Error is a commonly used metric to evaluate the 
%registration quality of monomodal images based on intensity differences. 
% It calculates the square root of the quantity by adding up the squared 
%intensity differences pixel by pixel and dividing the total by the number 
%of pixels minus one. The maximum value for an 8-bit picture would be 255. 
% Normalising the RMSE to a maximum value of one can be useful in facilitating 
%better comparisons across various studies.

% However, registration quality metrics based on intensity are not such
%reliable methods to evaluate the registration, as they tend to give more
%importance to errors that are resulting from the transformation on the
%image, resulting in overal high values. For instance, a slight blur that is the result of the registration
%may may cause intensity differences that are not directly caused by errors in 
%the registration algorithm but rather by the requirement to apply a spatial 
%transform to the image.

% Therefore, in general, metrics based on CP location error, such as the average 
%Euclidean distance in two independently extracted sets of CPs from the registered and 
%sensed images tend to be the more reliable.

% Relative RMSE: 0.018
% The relative RMSE indicates how much the pixel intensities differ from the original to the registered image, 
% normalized to the 8-bit scale (maximum value of 255).
% A relative RMSE of 0.083 suggests the registration has maintained reasonable accuracy.

% RMSE: 4.67
% This is the direct RMSE value of the pixel differences between the original and registered images. The error magnitude indicates the average pixel-level error across the images.
% An RMSE of 4.67 is relatively low given that pixel intensities range up to 255 in an 8-bit image. This means the registered image closely resembles the original in terms of pixel intensity.

%% CP locations
% 3.4.1 
% As it was mentioned it is better to use a CP location based metric to
% evaluate the registration. Since this method may have a tendency to
% overfit and result in very low differences in location of the CPs, if the
% we continue with the same features (SIFT), it is crucial to extract new
% CPs, with a different feature for evaluation. 

%Average Euclidean Distance (CP_loc_Error): 0.2017
% This is the mean Euclidean distance between the locations of corresponding feature points in the original and registered images.
% An error of 0.036 units indicates that the control points in the
% registered image are well-aligned with those in the original image as
% values around sub pixel indicate good quality.

%3.4.2 
% Another locaiton-based evaluation method is calculating the mean residual
% error, which is the average of the distribution of the CP extracted from the 
% reference and the registered images' differences in x or y coordinates. 

%Residual Errors:
%CP_Loc_error_residualx: 0.0491
%CP_Loc_error_residualy: 0.1344
%These values represent the average horizontal and vertical residual errors (in pixels) between the original and registered control points.
%The residual errors are very small, meaning that the control points align well horizontally and vertically. This indicates accurate alignment between the images.

%Maximum Displacement
%Max Horizontal Displacement: 0.72 pixels
%Max Vertical Displacement: 1.65 pixels
%These values represent the maximum shifts between corresponding control points horizontally and vertically.
%A maximum displacement of 1-2 pixels is minor and shows that even in the worst case, the registration maintains reasonable alignment.

%% Overall Analysis
%Collectively, these metrics suggest the following:

% Intensity Consistency: The low RMSE values imply that the pixel intensities of the registered image remain close to the original image.
% Geometric Alignment: The low Euclidean and residual errors show that the control points remain closely aligned after registration.
% Overall Quality: The low displacements and alignment errors indicate that the registration solution is quite effective and well within acceptable limits.

%%
%The registration solution appears to be accurate both in terms of intensity 
% and geometric alignment. The control point-based metrics verify the reliability 
% of the image registration solution, meaning our "Frankenstein" is likely to thrive.

%% Print variables:

disp('-> Step 1: Load images and perform initial SIFT feature detection and matching');
fprintf('Number of original image SIFT points: %d\n', CPs_Matlab_orig_det.Count);
fprintf('Number of transformed image SIFT points: %d\n', CPs_Matlab_t_det.Count);
fprintf('Number of matched pairs: %d\n\n', size(indexPairs, 1));

disp('Step 2: Compute RMSE for SIFT');
fprintf('RMSE value: %f\n', RMSE_SIFT);
fprintf('Relative RMSE value: %f\n\n', RMSE_rel_SIFT);

disp('-> Step 3: SURF feature detection and matching');
fprintf('Number of SURF points in original image: %d\n', CPs_eval_ref.Count);
fprintf('Number of SURF points in registered image: %d\n', CPs_eval_reg.Count);
fprintf('Number of matched SURF pairs: %d\n\n', size(indexPairs, 1));

disp('Computed location errors:');
fprintf('Average Euclidean distance error: %f\n', CP_Loc_error_euclidean);
fprintf('Mean residual error (x-axis): %f\n', CP_Loc_error_residualx);
fprintf('Mean residual error (y-axis): %f\n\n', CP_Loc_error_residualy);

fprintf('Maximum horizontal displacement: %f pixels\n', Max_horizontal_displacement);
fprintf('Maximum vertical displacement: %f pixels\n', Max_vertical_displacement);
