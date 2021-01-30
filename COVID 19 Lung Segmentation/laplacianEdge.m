function [edgeFilteredImg] = laplacianEdge(img)
%This is a general purpose laplacian zero threshold edge detection
%algorithm. It accepts an image and returns a zero threshold edge matrix
%particular to this application. The image is smoothed and the second derivative is calculated 
%simultaneously using a Laplacian of Gaussian filter. Due to the similarity between CT scans, a
%thresholding value of 166(related to the second derivative of the image)seems 
%to produce a suitable binary image.

img=double(img);
width = size(img,2);
height = size(img,1);
lgKernel=lapGauKernel();

imgPad=[repmat(img(1,:),4,1);img;repmat(img(height,:),4,1)];
imgPad=[repmat(imgPad(:,1),1,4),imgPad,repmat(imgPad(:,width),1,4)];
temp=imgPad; %Pad image for convolution with Laplacian of Gaussian kernel
for i=5:width %Perform convolution
    for j=5:height
        temp(j,i)=sum(imgPad(j-4:j+4,i-4:i+4).*lgKernel(1:9,1:9),'all');
    end
end



temp = uint8(255 * mat2gray(temp)); %[5] in references
%normalize smoothed image
temp2=temp;

for i=1:size(temp2,2)%zero threshold edge detection to produce binary edges
    for j=1:size(temp2,1)
        if temp2(j,i)>165
            temp2(j,i)=255;
        else
            temp2(j,i)=0;
        end
    end
end

temp2(1:4,:)=[]; %remove padding to maintain size consistency
temp2(height:height+3,:)=[];
temp2(:,1:4)=[];
temp2(:,width:width+3)=[];
figure
imshow(temp2)
title({'Figure 6. Zero-Threshold Laplacian Filtered Image'})
edgeFilteredImg=temp2;
end

