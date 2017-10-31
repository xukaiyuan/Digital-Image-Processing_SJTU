clear all;
clc;
addpath('Solver');
addpath('Sparse coding');
patch_size = 3; 
overlap = 1; 
lambda = 0.1; 
zooming = 3; 
tr_dir = 'Data/training'; 
skip_smp_training = true; 
skip_dictionary_training = true;
num_patch = 50000; 
codebook_size = 1024; 
 
if ~skip_smp_training,
    disp('Sampling image patches...');
    [Xh, Xl] = rnd_smp_dictionary(tr_dir, patch_size, zooming, num_patch);
    save('Data/Dictionary/smp_patches.mat', 'Xh', 'Xl');
    skip_dictionary_training = false;
end;

if ~skip_dictionary_training,
    load('Data/Dictionary/smp_patches.mat');
    [Dh, Dl] = coupled_dic_train(Xh, Xl, codebook_size, lambda);
    save('Data/Dictionary/Dictionary.mat', 'Dh', 'Dl');
else
    load('Data/Dictionary/Dictionary.mat');
end;
fname = 'Data/Test/1.bmp';
testIm = imread(fname); 
if rem(size(testIm,1),zooming) ~=0,
    nrow = floor(size(testIm,1)/zooming)*zooming;
    testIm = testIm(1:nrow,:,:);
end;
if rem(size(testIm,2),zooming) ~=0,
    ncol = floor(size(testIm,2)/zooming)*zooming;
    testIm = testIm(:,1:ncol,:);
end;
imwrite(testIm, 'Data/Test/high.bmp', 'BMP');
lowIm = imresize(testIm,1/zooming, 'bicubic');
imwrite(lowIm,'Data/Test/low.bmp','BMP');
interpIm = imresize(lowIm,zooming,'bicubic');
imwrite(uint8(interpIm),'Data/Test/bb.bmp','BMP');
lowIm2 = rgb2ycbcr(lowIm);
lImy = double(lowIm2(:,:,1));
interpIm2 = rgb2ycbcr(interpIm);
hImcb = interpIm2(:,:,2);
hImcr = interpIm2(:,:,3);
[hImy] = L1SR(lImy, zooming, patch_size, overlap, Dh, Dl, lambda);
ReconIm(:,:,1) = uint8(hImy);
ReconIm(:,:,2) = hImcb;
ReconIm(:,:,3) = hImcr;
nnIm = imresize(lowIm, zooming, 'nearest');
ReconIm = ycbcr2rgb(ReconIm);
figure,imshow(ReconIm,[]);
imwrite(uint8(ReconIm),'Data/Test/L1SR.bmp','BMP');