function [isoImgCoord] = lungsIsolation(img)
%This function takes a binary image of a lung CT scan and returns only the
%coordinates of the lung areas. Using Matlab's algorithm for detecting
%connected components, the background is first removed, then the lungs are
%kept by virtue of being the two largest objects. The returned matrix has a
%value of 0 for the background and blood vessels, and 1 for the lung areas.
%Some code in this function is directly from MathWorks [7]

width = size(img,2);
height = size(img,1);
sz=[height width];

conObjects=bwconncomp(img,4);%finds all connected objects (not diagonal) and labels them

for i=1:conObjects.NumObjects
    [row,column]=ind2sub(sz,conObjects.PixelIdxList{1,i});
    if ismember(1,row) || ismember(1,column) || ismember(height,row) || ismember(width,column)
        img(conObjects.PixelIdxList{1,i}) = 0; %set all background objects to zero and crop to image of body
    end
end
conObjects=bwconncomp(img,4);%only connected objects within the body
bigI=0; %lungs will be two largest objects in ct scan when background is removed
secbigI=0;
for i=1:conObjects.NumObjects
    if bigI==0
        bigI=i;
        continue
    end
    if secbigI==0
        secbigI=i;
        continue
    end
    numPixels = numel(conObjects.PixelIdxList{1,i}); %count number of pixels in object
    if numPixels < numel(conObjects.PixelIdxList{1,bigI})
        if numPixels < numel(conObjects.PixelIdxList{1,secbigI})
            img(conObjects.PixelIdxList{1,i}) = 0;
        else
            img(conObjects.PixelIdxList{1,secbigI}) = 0;
            secbigI=i;
        end
    else
        img(conObjects.PixelIdxList{1,secbigI}) = 0;
        secbigI=bigI;
        bigI=i;
    end
end
figure
imshow(img)
title({'Figure 3. Inverted Binary Mask of Isolated Lungs'})


isoImgCoord=img; %isolated lung coordinates
end

