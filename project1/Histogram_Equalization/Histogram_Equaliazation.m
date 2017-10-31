function Histogram_Equaliazation()
Ig = imread('3.8(a).tif'); 
I=rgb2gray(Ig);
figure(1);
imhist(I);
title('the histogram of the original image');
[h,w]=size(Ig);
pr=zeros(1,256);
ps=zeros(1,256);
for i=1:h 
    for j=1:w  
     pr(Ig(i,j) + 1) = pr(Ig(i,j) + 1)  + 1;  
    end  
end  


ps(1)=pr(1);
for i=2:256
    ps(i)=ps(i-1)+pr(i);
end;


for i=1:256
   ps(i)=ps(i)*256/(h*w);   
end;


for i=1:h
    for j=1:w
        Ig(i,j)=ps(Ig(i,j)+1);
    end;
end;

%imshow(Ig);

pe=zeros(1,256);
for i=1:h 
    for j=1:w  
     pe(Ig(i,j) + 1) = pe(Ig(i,j) + 1)  + 1;  
    end  
end

figure(2);
imhist(Ig);
title('the histogram of the equalized image');
figure(3);
imshow(Ig);
end