clc
clear all
close all

% Activity 1

% 1. Loading and showing the reference image, without and with imref2d
% (image reference frame)

im_ref = imread('coin.png');
figure;
imshow(im_ref);
title('Spatial reference frame unknown');

Rcb_ref = imref2d(size(im_ref));
figure;
imshow(im_ref,Rcb_ref);
title('Original Image');
imwrite(im_ref,"Ref.png");

%%
% Applying the first transformation

T = [1 0 0; -0.3 1 0; 0 0 1]; % Horizontal Shearing, an affine transformation
Tform_aff = affine2d(T);
[im_aff, Rtr] = imwarp(im_ref, Tform_aff);
figure;
imshow(im_aff, Rtr);
title("Affine transformation, Horizontal shearing")
imwrite(im_aff,"Transformed_im.png");

% Show your results, with the appropriate reference frames

figure;
subplot(1,2,1);
imshow(im_ref,Rcb_ref);title('Original image');
subplot(1,2,2);
imshow(im_aff,Rtr);title('Transformed image, Horizontal shearing');
saveas(gcf,"Twoimages_approriateframes.png");

% Using the 'OutputView' parameter in the call to the imwarp function to
% have the same reference frame

[im_aff,Rtr] = imwarp(im_ref,Tform_aff,'OutputView',Rcb_ref);

figure;
subplot(1,2,1);
imshow(im_ref,Rcb_ref);title('Original image');
subplot(1,2,2);
imshow(im_aff,Rtr);title('Transformed image, Horizontal shearing');
saveas(gcf,"Twoimages_sameframes.png");

%%
% Apply the second transformation
T2 = ([cosd(10) sind(10) 0; -sind(10) cosd(10) 0; 10 10 1]);
Tform_rigid = affine2d(T2);
[im_rigid, Rri] = imwarp(im_ref, Tform_rigid);
figure;
subplot(1,2,1);
imshow(im_ref,Rcb_ref);title('Original image');
subplot(1,2,2);
imshow(im_rigid,Rri);title('Rigid Transformation');
saveas(gcf,"Twoimages_rigid.png");


[im_rigid, Rri] = imwarp(im_ref, Tform_rigid,'OutputView',Rcb_ref);
figure;
subplot(1,2,1);
imshow(im_ref,Rcb_ref);title('Original image');
subplot(1,2,2);
imshow(im_rigid,Rri);title('Rigid Transformation');
saveas(gcf,"Twoimages_sameframes_rigid.png");