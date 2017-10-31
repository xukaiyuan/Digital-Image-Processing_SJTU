function Laplacian_sharpen(L)
if length(L)-9 ~= 0
    disp('error input');
else
    if L(5)>=0
         c=1;
    else c=-1;
    end;
    I = imread('3.38(a).tif');
    I=double(I);
    [h,w]=size(I);
    g=zeros(h,w);
    for i=2:h-1
        for j=2:w-1
        g(i,j)=L(1)*I(i-1,j-1)+L(2)*I(i-1,j)+L(3)*I(i-1,j+1)+L(4)*I(i,j-1)+L(5)*I(i,j)+L(6)*I(i,j+1)+L(7)*I(i+1,j-1)+L(8)*I(i+1,j)+L(9)*I(i+1,j+1); 
        
        end;
    end;
    
    for i=1:h
        for j=1:w
        Ix(i,j)=I(i,j)+c*g(i,j);
        end;
    end;
    
   imshow(uint8(Ix),'3.38(a)_LS.tif'); 
   
end;

end

