% Class exercise 3
clc
clear all
close all

%% Transformation 1 - SIFT
% Step 1. Execute your Activity 2 code, and get the CP sets for the reference and sensed images (full set, no CP reduction)
% a) Read image and show it
im_orig=imread('coin.png'); 
rc = imref2d(size(im_orig));
CPs_Matlab_orig_det = detectSIFTFeatures(im_orig);
[CPs_Matlab_orig_feat,  CPs_Matlab_orig_ext]  = extractFeatures(im_orig, CPs_Matlab_orig_det);
tform = affine2d([1 0 0; -0.3 1 0; 0 0 1]);
[im_t,Rtr] = imwarp(im_orig, tform);
rt = imref2d(size(im_t));
CPs_Matlab_t_det= detectSIFTFeatures(im_t);
[CPs_Matlab_t_feat,  CPs_Matlab_t_ext]  = extractFeatures(im_t,  CPs_Matlab_t_det);

% Step 2. Match the two sets using the matchFeatures function.

% Note that the inputs are the feature values, not the CPs_extracted sets;
% We keep all the CPs extracted, since this is beneficial for having more matched candidates
[indexPairs, ~] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat,'Unique',true);
% We extract the selected matched points from the CP sets in the reference and sensed images
matched_set_ref = CPs_Matlab_orig_ext(indexPairs(:,1));
matched_set_sen = CPs_Matlab_t_ext(indexPairs(:,2));

% Step 3. Show the matched candidates using the ShowmatchedFeatures function. Read the function documentation first
figure,ax=axes;
showMatchedFeatures(im_orig, im_t, matched_set_ref, matched_set_sen, 'montage','Parent', ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points Ref','Matched points Sensed');

% We are not satisfied with the matching. Seems like two pairs are not correct and we have crossings

% Step 4. Matching process parameter tuning
% Change any of these parameters: Matchthreshold, Maxratio, Metric, we use
% maratio, which its defult is 0.6

MaxRatios = [0.9, 0.7, 0.5, 0.4];
for i = 1:length(MaxRatios)
    [indexPairs, matchMetrics] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat, 'Unique', true, 'MaxRatio', MaxRatios(i));

    matched_set_ref = CPs_Matlab_orig_ext(indexPairs(:,1));
    matched_set_sen = CPs_Matlab_t_ext(indexPairs(:,2));

    % Show results
    figure, ax = axes;
    showMatchedFeatures(im_orig, im_t, matched_set_ref, matched_set_sen, 'montage', 'Parent', ax);
    title(ax, ['Candidate Point Matches with MaxRatio = ', num2str(MaxRatios(i))]);
    legend(ax, 'Matched points Ref', 'Matched points Sensed');

    % Descriptive statistics of match scores
    meanScore = mean(matchMetrics);
    medianScore = median(matchMetrics);
    stdScore = std(matchMetrics);
    numMatches = length(matchMetrics);
    
    disp(['-----> MaxRatio = ', num2str(MaxRatios(i)), ':']);
    disp(['Number of Matches = ', num2str(numMatches)]);
    disp(['Mean Score = ', num2str(meanScore)]);
    disp(['Median Score = ', num2str(medianScore)]);
    disp(['Standard Deviation of Scores = ', num2str(stdScore)]);
end

%% Transformation 1 - BRISK
CPs_Matlab_orig_det = detectBRISKFeatures(im_orig);
[CPs_Matlab_orig_feat,  CPs_Matlab_orig_ext]  = extractFeatures(im_orig, CPs_Matlab_orig_det);
tform = affine2d([1 0 0; -0.3 1 0; 0 0 1]);
[im_t,Rtr] = imwarp(im_orig, tform);
rt = imref2d(size(im_t));
CPs_Matlab_t_det= detectBRISKFeatures(im_t);
[CPs_Matlab_t_feat,  CPs_Matlab_t_ext]  = extractFeatures(im_t,  CPs_Matlab_t_det);

% Step 2. Match the two sets using the matchFeatures function.

% Note that the inputs are the feature values, not the CPs_extracted sets;
% We keep all the CPs extracted, since this is beneficial for having more matched candidates
[indexPairs, ~] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat,'Unique',true);
% We extract the selected matched points from the CP sets in the reference and sensed images
matched_set_ref = CPs_Matlab_orig_ext(indexPairs(:,1));
matched_set_sen = CPs_Matlab_t_ext(indexPairs(:,2));

% Step 3. Show the matched candidates using the ShowmatchedFeatures function. Read the function documentation first
figure,ax=axes;
showMatchedFeatures(im_orig, im_t, matched_set_ref, matched_set_sen, 'montage','Parent', ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points Ref','Matched points Sensed');

% We are not satisfied with the matching. Seems like two pairs are not correct and we have crossings

% Step 4. Matching process parameter tuning
% Change any of these parameters: Matchthreshold, Maxratio, Metric, we use
% maratio, which its defult is 0.6

MaxRatios = [0.9, 0.7, 0.5, 0.4];
for i = 1:length(MaxRatios)
    [indexPairs, matchMetrics] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat, 'Unique', true, 'MaxRatio', MaxRatios(i));

    matched_set_ref = CPs_Matlab_orig_ext(indexPairs(:,1));
    matched_set_sen = CPs_Matlab_t_ext(indexPairs(:,2));

    % Show results
    figure, ax = axes;
    showMatchedFeatures(im_orig, im_t, matched_set_ref, matched_set_sen, 'montage', 'Parent', ax);
    title(ax, ['Candidate Point Matches with MaxRatio = ', num2str(MaxRatios(i))]);
    legend(ax, 'Matched points Ref', 'Matched points Sensed');

    % Descriptive statistics of match scores
    meanScore = mean(matchMetrics);
    medianScore = median(matchMetrics);
    stdScore = std(matchMetrics);
    numMatches = length(matchMetrics);
    
    disp(['-----> MaxRatio = ', num2str(MaxRatios(i)), ':']);
    disp(['Number of Matches = ', num2str(numMatches)]);
    disp(['Mean Score = ', num2str(meanScore)]);
    disp(['Median Score = ', num2str(medianScore)]);
    disp(['Standard Deviation of Scores = ', num2str(stdScore)]);
end

%% Transformation 2 - SIFT
im_orig=imread('coin.png'); 
rc = imref2d(size(im_orig));
CPs_Matlab_orig_det = detectSIFTFeatures(im_orig);
[CPs_Matlab_orig_feat,  CPs_Matlab_orig_ext]  = extractFeatures(im_orig, CPs_Matlab_orig_det);
T2 = ([cosd(10) sind(10) 0; -sind(10) cosd(10) 0; 10 10 1]);
Tform_rigid = affine2d(T2);
[im_rigid, Rri] = imwarp(im_orig, Tform_rigid);
CPs_Matlab_t_det2= detectSIFTFeatures(im_rigid);
[CPs_Matlab_t_feat2,  CPs_Matlab_t_ext2]  = extractFeatures(im_rigid,  CPs_Matlab_t_det2);

[indexPairs, ~] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat2,'Unique',true);
% We extract the selected matched points from the CP sets in the reference and sensed images
matched_set_ref = CPs_Matlab_orig_ext(indexPairs(:,1));
matched_set_sen = CPs_Matlab_t_ext2(indexPairs(:,2));

figure,ax=axes;
showMatchedFeatures(im_orig, im_rigid, matched_set_ref, matched_set_sen, 'montage','Parent', ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points Ref','Matched points Sensed');

% Fine tuning

MaxRatios = [0.9, 0.7, 0.5, 0.4];
for i = 1:length(MaxRatios)
    [indexPairs, matchMetrics] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat2, 'Unique', true, 'MaxRatio', MaxRatios(i));

    matched_set_ref = CPs_Matlab_orig_ext(indexPairs(:,1));
    matched_set_sen = CPs_Matlab_t_ext2(indexPairs(:,2));

    % Show results
    figure, ax = axes;
    showMatchedFeatures(im_orig, im_rigid, matched_set_ref, matched_set_sen, 'montage', 'Parent', ax);
    title(ax, ['Candidate Point Matches with MaxRatio = ', num2str(MaxRatios(i))]);
    legend(ax, 'Matched points Ref', 'Matched points Sensed');

    % Descriptive statistics of match scores
    meanScore = mean(matchMetrics);
    medianScore = median(matchMetrics);
    stdScore = std(matchMetrics);
    numMatches = length(matchMetrics);
    
    disp(['-----> MaxRatio = ', num2str(MaxRatios(i)), ':']);
    disp(['Number of Matches = ', num2str(numMatches)]);
    disp(['Mean Score = ', num2str(meanScore)]);
    disp(['Median Score = ', num2str(medianScore)]);
    disp(['Standard Deviation of Scores = ', num2str(stdScore)]);
end

%% Transformation 2 - BRISK

im_orig=imread('coin.png'); 
rc = imref2d(size(im_orig));
CPs_Matlab_orig_det = detectBRISKFeatures(im_orig);
[CPs_Matlab_orig_feat,  CPs_Matlab_orig_ext]  = extractFeatures(im_orig, CPs_Matlab_orig_det);
T2 = ([cosd(10) sind(10) 0; -sind(10) cosd(10) 0; 10 10 1]);
Tform_rigid = affine2d(T2);
[im_rigid, Rri] = imwarp(im_orig, Tform_rigid);
CPs_Matlab_t_det2= detectBRISKFeatures(im_rigid);
[CPs_Matlab_t_feat2,  CPs_Matlab_t_ext2]  = extractFeatures(im_rigid,  CPs_Matlab_t_det2);

[indexPairs, ~] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat2,'Unique',true);
% We extract the selected matched points from the CP sets in the reference and sensed images
matched_set_ref = CPs_Matlab_orig_ext(indexPairs(:,1));
matched_set_sen = CPs_Matlab_t_ext2(indexPairs(:,2));

figure,ax=axes;
showMatchedFeatures(im_orig, im_rigid, matched_set_ref, matched_set_sen, 'montage','Parent', ax);
title(ax, 'Candidate point matches');
legend(ax, 'Matched points Ref','Matched points Sensed');

% Fine tuning

MaxRatios = [0.9, 0.7, 0.5, 0.4];
for i = 1:length(MaxRatios)
    [indexPairs, matchMetrics] = matchFeatures(CPs_Matlab_orig_feat, CPs_Matlab_t_feat2, 'Unique', true, 'MaxRatio', MaxRatios(i));

    matched_set_ref = CPs_Matlab_orig_ext(indexPairs(:,1));
    matched_set_sen = CPs_Matlab_t_ext2(indexPairs(:,2));

    % Show results
    figure, ax = axes;
    showMatchedFeatures(im_orig, im_rigid, matched_set_ref, matched_set_sen, 'montage', 'Parent', ax);
    title(ax, ['Candidate Point Matches with MaxRatio = ', num2str(MaxRatios(i))]);
    legend(ax, 'Matched points Ref', 'Matched points Sensed');

    % Descriptive statistics of match scores
    meanScore = mean(matchMetrics);
    medianScore = median(matchMetrics);
    stdScore = std(matchMetrics);
    numMatches = length(matchMetrics);
    
    disp(['-----> MaxRatio = ', num2str(MaxRatios(i)), ':']);
    disp(['Number of Matches = ', num2str(numMatches)]);
    disp(['Mean Score = ', num2str(meanScore)]);
    disp(['Median Score = ', num2str(medianScore)]);
    disp(['Standard Deviation of Scores = ', num2str(stdScore)]);
end

