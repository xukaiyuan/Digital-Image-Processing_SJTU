function blurring_filter(a,b,T)
I = imread('book_cover.jpg');
f=double(I);
[h,w]=size(f);
[V,U] = meshgrid(1:w, 1:h);
U = U - floor( h/2 );
V = V - floor( w/2 );

uavb = pi*( U*a + V*b + eps);
H = T./uavb .* sin( uavb ) .* exp( -1j*uavb );
H = ifftshift( H );

F = fft2( f );
Fp = H.*F;
bi = real( ifft2(Fp) );
bi = im2uint8( mat2gray(bi) );
imwrite(bi,'book_cover_blur.png');



end

