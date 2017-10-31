function frequency_domain(n,d0)
I = imread('4.41(a).tif');
f=double(I);
g=fft2(f);
g=fftshift(g);
[h,w]=size(g);
p=fix(h/2);
q=fix(w/2);
switch n
    case{1}%%ieal lowpass filter
    for i=1:h
        for j=1:w
            d=sqrt((i-p)^2+(j-q)^2);
            if d <= d0
            h=1;
            else h=0;
            end;
            r1(i,j)=h*g(i,j);
        end;
    end;
    r1=ifftshift(r1);
    r=ifft2(r1);
    imshow(uint8(r));
    %%imwrite(uint8(r),'4.41(a)_lp_.tif')
    case {2}%%buterworth lowpass filter
    bc=input('input the buterworth order bc=');
    bc=bc*2;
    for i=1:h
        for j=1:w
            d=sqrt((i-p)^2+(j-q)^2);
            h=1/(1+(d/d0)^bc);
            r1(i,j)=h*g(i,j);
        end;
   end; 
   r1=ifftshift(r1);
   r=ifft2(r1);
   imshow(uint8(r));
    
   case {3} %%gaussian lowpass filter
   for i=1:h
        for j=1:w
            d=sqrt((i-p)^2+(j-q)^2);
            h=exp(-d^2/2/d0^2);
            r1(i,j)=h*g(i,j);
        end;
    end;
    r1=ifftshift(r1);
    r=ifft2(r1);
    imshow(uint8(r));
    
    case {4}%%ideal highpass filter
    for i=1:h
        for j=1:w
            d=sqrt((i-p)^2+(j-q)^2);
            if d <= d0
            h=0;
            else h=1;
            end;
            r1(i,j)=h*g(i,j);
        end;
    end;
    r1=ifftshift(r1);
    r=ifft2(r1);
    imshow(uint8(r));
    
     case {5}%%buterworth highpass filter
     bc=input('input the buterworth order bc=');
     bc=bc*2;
     for i=1:h
          for j=1:w
              d=sqrt((i-p)^2+(j-q)^2);
              h=1/(1+(d0/d)^bc);
              r1(i,j)=h*g(i,j);
          end;
      end; 
      r1=ifftshift(r1);
      r=ifft2(r1);
      imshow(uint8(r));
     
    
      case {6} %%gaussian highpass filter
       for i=1:h
            for j=1:w
            d=sqrt((i-p)^2+(j-q)^2);
            h=1-exp(-d^2/2/d0^2);
            r1(i,j)=h*g(i,j);
            end;
       end;
       r1=ifftshift(r1);
       r=ifft2(r1);
       imshow(uint8(r));
    
end;
clear;
end

