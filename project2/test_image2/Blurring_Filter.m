image = imread('book_cover.jpg');

f = double(image);
f = fft2(f);
f = fftshift(f);

[M, N] = size(f);  % 688 * 688
a = 0.1; b = 0.1; T = 1;
H = zeros(M, N);
G = zeros(M, N);

for x = 1 : M
    for y = 1 : N
        H(x, y) = T * sin(pi * (a * x + b * y)) * (cos(pi * (a * x + b * y)) - j * sin(pi * (a * x + b * y))) / (pi * (a * x + b * y)) ;
        %H(x, y) = T * sin(pi * (a * x + b * y)) * exp(- j * pi * (a * x + b * y)) / (pi * (a * x + b * y)) ;
        G(x, y) = H(x, y) * f(x, y);
    end
end

result = ifftshift(G);
result = ifft2(result);
result = abs(result);
max(max(result))
result = uint8(result * 256);

%result
imshow(result);

