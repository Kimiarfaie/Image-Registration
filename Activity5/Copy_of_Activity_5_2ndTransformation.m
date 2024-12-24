% Class exercise 5. BLANK CODE
%% Step 1. Execute your Activity 4 code, and get the original and registered images with the best solution you have been able to find
im_orig=imread('coin.png'); 
rc = imref2d(size(im_orig));
CPs_Matlab_orig_det = detectBRISKFeatures(im_orig);
[CPs_Matlab_orig_feat,  CPs_Matlab_orig_ext]  = extractFeatures(im_orig, CPs_Matlab_orig_det);
T2 = ([cosd(10) sind(10) 0; -sind(10) cosd(10) 0; 10 10 1]);
Tform_rigid = affine2d(T2);
[im_rigid, Rri] = imwarp(im_orig, Tform_rigid);
CPs_Matlab_t_det2= detectBRISKFeatures(im_rigid);
[CPs_Matlab_t_feat2,  CPs_Matlab_t_ext2]  = extractFeatures(im_rigid,  CPs_Matlab_t_det2);
[indexPairs,~] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat2,'Unique',true,'MaxRatio',0.42);

matched_set_ref=CPs_Matlab_orig_ext(indexPairs(:,1));
matched_set_sen=CPs_Matlab_t_ext2(indexPairs(:,2));

tform_est2 = estgeotform2d(matched_set_sen, matched_set_ref, "affine");

outputView = imref2d(size(im_orig));
im_reg2  = imwarp(im_rigid, tform_est2, OutputView = outputView);
%% Step 2. Implement an intensity-based quality metric (RMSE)

% It might be convenient to stack the image data before the computation of
% the vector of pixel-by-pixel differences

pix_orig=im_orig(:);
pix_reg=im_reg2(:);

%COMPLETE CODE HERE TO COMPUTE THE RMSE ACCORDING TO THE EQUATION IN SLIDE
%58
RMSE = sqrt((1/(-1+length(pix_orig)))*sum((pix_orig-pix_reg).^2));

%Compute the relative value, assuming an 8-bit image (maximum value of RMSE
%= 255)
RMSE_rel=RMSE/255;


%% Step 3. Implement a CP-location-based quality metric. 

% 3.1. Extract anew CP in the original and registered images, using a
% different feature than the one you used for solving the registration
% problem

CPs_eval_ref = detectFASTFeatures(im_orig);
CPs_eval_reg = detectFASTFeatures(im_reg2);

[CPs_eval_ref_feat,  CPs_eval_ref_ext]  = extractFeatures(im_orig,  CPs_eval_ref);
[CPs_eval_reg_feat,  CPs_eval_reg_ext]  = extractFeatures(im_reg2,  CPs_eval_reg);

%3.2. Match both and show the results

[indexPairs,matchmetric] = matchFeatures(CPs_eval_ref_feat, CPs_eval_reg_feat, 'Unique',true);
matched_set_ref=CPs_eval_ref_ext(indexPairs(:,1));
matched_set_reg=CPs_eval_reg_ext(indexPairs(:,2));

% Show the results Using showMatchedFeatures function
figure, ax=axes;
showMatchedFeatures(im_orig, im_reg2, matched_set_ref, matched_set_reg,'montage','Parent',ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points Ref','Matched points Registered');

% Show the results using a plot of CP locations with different symbols
figure
imshow(im_orig)
hold on
plot(matched_set_ref.Location(:,1), matched_set_ref.Location(:,2), 'ro');
plot(matched_set_reg.Location(:,1),matched_set_reg.Location(:,2),'bx');
legend(' Original', 'Registered');


% 3.3. Refine previous steps if you don't get a full set of correct matches
%%
% 3.4. Compute the Euclidean average distance between matched CPsdiff = matched_set_ref.Location - matched_set_reg.Location;

diff = matched_set_ref.Location-matched_set_reg.Location;

CP_Loc_error = (1/(size(matched_set_ref,1)-1))*sum(sqrt((diff(:,1).^2+diff(:,2).^2)));

%Maximum displacement in the horizontal and vertical directions
Max_horizontal_displacement = max(abs(diff(:, 1)));
Max_vertical_displacement = max(abs(diff(:, 2)));


