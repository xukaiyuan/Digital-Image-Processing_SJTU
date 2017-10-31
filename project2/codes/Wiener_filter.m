function Wiener_filter (a,b,T,m,v)
f = imread('book_cover.jpg');
[h,w]=size(f);
[V,U] = meshgrid(1:w, 1:h);
U = U - floor( h/2 );
V = V - floor( w/2 );
uavb = pi*( U*a + V*b + eps);
H = T./uavb .* sin( uavb ) .* exp( -1j*uavb );
H = ifftshift( H );
I2 = imread('book_cover_blur.png');
j= imnoise(I2,'gaussian',m/255,v/255/255);
n=j-I2;
n=fft2(n);
F = fft2( f );


Sn = abs(n) .^ 2;
Sf = abs(F) .^ 2;

G = F .* H+n;

fi= ((abs(H) .^ 2) ./ (H .* (abs(H) .^ 2 + Sn ./ Sf))) .* G;
fi=ifft2(fi);
fi = im2uint8(mat2gray(real(fi)));

imshow(fi);
imwrite(fi,'recover_wiener.png');
end