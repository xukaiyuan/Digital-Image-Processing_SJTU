function add_gaussian_noise(m,v)
I = imread('book_cover_blur.png');
j= imnoise(I,'gaussian',m/255,v/255/255);
figure(1);
imshow(j);
imwrite(j,'book_cover_blur_gaussian.png');
end

