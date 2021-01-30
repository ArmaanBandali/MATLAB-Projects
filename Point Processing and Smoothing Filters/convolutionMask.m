function [maskedImage] = convolutionMask(sampleImage,kSize)
%This function performs spatial filtering of an image by convolving a
%kSize x kSize uniform averaging kernel with the sampleImage.
%
%sampleImage must be a grayscale image matrix of any type and kSize must be
%an odd positive integer
%maskedImage returns a grayscale 'smoothed' uint8 image matrix
%
%Parts of the kernel may be outside the image.
%For these border pixels, kernel values outside the image
%are ignored when summing the convolution, equivalent to
%assuming pixels outside the image are black.

sampleImage = double(sampleImage);
width = size(sampleImage,2);
height = size(sampleImage,1);
if width > height %sampleImage must be scaled to square dimensions to match kernel
    %if width is greater than height, scale the width, or vice-versa
    sampleImage = imresize(sampleImage,'Scale',[1,height/width]);
    width = height;
else
    sampleImage = imresize(sampleImage,'Scale',[width/height,1]);
    height = width;
end
smoothingFactor = 1/(kSize^2); %smoothing factor is equal to the inverse of the kernel size squared

for n = 1:width
    for m = 1:height %n and m loops go over every pixel in image
        temp = 0; %temp variable is required because sampleImage(m,n)
                  %contributes to convolution sum
        for alpha = -1*(kSize/2)+0.5:kSize/2-0.5 %kernel size determines convolution bounds
            if n+alpha < 1 || n+alpha > height 
                continue %ignore pixels outside of image
            end
            for beta = -1*(kSize/2)+0.5:kSize/2-0.5
                if m+beta < 1 || m+beta > height
                    continue %ignore pixels outside of image
                end
                %Sum the weights of each neighbouring pixel in the
                %convolution
                temp=smoothingFactor*(sampleImage(m+beta,n+alpha))+temp;
            end
        end
        sampleImage(m,n) = temp;
    end
end

maskedImage=sampleImage;
maskedImage=uint8(maskedImage);
end

