function [hIm] = L1SR(lIm, zooming, patch_size, overlap, Dh, Dl, lambda)
[lhg, lwd] = size(lIm);
h = lhg*zooming;
l = lwd*zooming;
mIm = imresize(lIm, 2,'bicubic');
h_size = patch_size*zooming;
m_size = patch_size*2;%%pre-process of the input image
hf1 = [-1,0,1];
vf1 = [-1,0,1]';
hf2 = [1,0,-2,0,1];
vf2 = [1,0,-2,0,1]';%%parameters of the function f
lImG11 = conv2(mIm,hf1,'same');
lImG12 = conv2(mIm,vf1,'same');
lImG21 = conv2(mIm,hf2,'same');
lImG22 = conv2(mIm,vf2,'same');
lImfea(:,:,1) = lImG11;
lImfea(:,:,2) = lImG12;
lImfea(:,:,3) = lImG21;
lImfea(:,:,4) = lImG22;
lgridx = 2:patch_size-overlap:lwd-patch_size;
lgridx = [lgridx, lwd-patch_size];
lgridy = 2:patch_size-overlap:lhg-patch_size;
lgridy = [lgridy, lhg-patch_size];
mgridx = (lgridx - 1)*2 + 1;
mgridy = (lgridy - 1)*2 + 1;
bhIm = imresize(lIm, 3, 'bicubic');
hIm = zeros([h, l]);
nrml_mat = zeros([h, l]);
hgridx = (lgridx-1)*zooming + 1;
hgridy = (lgridy-1)*zooming + 1;
for xx = 1:length(mgridx),%%do the reconstruciton of the patches x
    for yy = 1:length(mgridy),    
        mcolx = mgridx(xx);
        mrowy = mgridy(yy);
        mpatch = mIm(mrowy:mrowy+m_size-1, mcolx:mcolx+m_size-1);
        mmean = mean(mpatch(:));      
        mpatchfea = lImfea(mrowy:mrowy+m_size-1, mcolx:mcolx+m_size-1, :);
        mpatchfea = mpatchfea(:);
        mnorm = sqrt(sum(mpatchfea.^2));
        if mnorm > 1,
            y = mpatchfea./mnorm;
        else
            y = mpatchfea;
        end;      
        w = SolveLasso(Dl, y, size(Dl, 2), 'nnlasso', [], lambda);      %% calculate the parameter alpha 
        if isempty(w),
            w = zeros(size(Dl, 2), 1);
        end; 
        if mnorm > 1,
              hpatch = Dh*w*mnorm;
         else
               hpatch = Dh*w;
         end;      
     
        hpatch = reshape(hpatch, [h_size, h_size]);
        hpatch = hpatch + mmean;        
        hcolx = hgridx(xx);
        hrowy = hgridy(yy);    
        hIm(hrowy:hrowy+h_size-1, hcolx:hcolx+h_size-1)...
            = hIm(hrowy:hrowy+h_size-1, hcolx:hcolx+h_size-1) + hpatch;
        nrml_mat(hrowy:hrowy+h_size-1, hcolx:hcolx+h_size-1)...
            = nrml_mat(hrowy:hrowy+h_size-1, hcolx:hcolx+h_size-1) + 1;
    end;
end;
hIm(1:3, :) = bhIm(1:3, :);
hIm(:, 1:3) = bhIm(:, 1:3);
hIm(end-2:end, :) = bhIm(end-2:end, :);
hIm(:, end-2:end) = bhIm(:, end-2:end);
nrml_mat(nrml_mat < 1) = 1;
hIm = hIm./nrml_mat;
hIm = uint8(hIm);

