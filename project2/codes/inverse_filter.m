function inverse_filter (a,b,T,m,v)
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
x0=fix(h/2);
y0=fix(w/2);
J=fft2(j);
for x=1:h
    for y=1:w
        d=sqrt((x-x0)^2+(y-y0)^2);
        if (d < 100)
            fi(x,y)=F(x,y)+n(x,y)/H(x,y);
            %fi(x,y)=j(x,y)/H(x,y);
        else
            fi(x,y)=J(x,y);
        end;
    end;
end;

%fi=j1./H;
fi=ifft2(fi);
fi = im2uint8(mat2gray(real(fi)));

imshow(fi);
imwrite(fi,'recover_inverse.png');
end

