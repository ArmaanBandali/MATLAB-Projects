function [binImg] = otsuMethod(img)
%This function accepts an image and applies Matlab's implementation of
%Otsu's segmentation method to produce a binary image
%This code follows directly from [8]

level=graythresh(uint8(img))*255;%Otsu's method matlab
binImg = imbinarize(img,level); %Normalize to [0 1]
end

