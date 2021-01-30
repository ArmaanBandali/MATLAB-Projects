close all
I = imread('Images\Capture.jpg');
J = double(I);
H = (J(:,:,1)+J(:,:,2)+J(:,:,3))/3; %Grayscale image by averaging RGB channels
H = uint8(H); %Conversion from double back to uint8 before using imshow


height = size(H,1);
width = size(H,2);

dupl = H; %Flip image right side up for cartesian coordinates
for x = 1:width
    j = height;
    for y = 1:height
        H(y,x)=dupl(j,x);
        j=j-1;
    end
end

[r, theta] = meshgrid(0:min(height,width)-1,0:pi/(2*height):pi/2-pi/(2*height));
x = r.*cos(theta);
y = r.*sin(theta);
figure
subplot(121)
imshow(dupl)
title('Figure 1. Original and Transformed Images')
colormap('gray')
subplot(122)
surf(x,y,H, 'EdgeColor', 'none')
axis square
view(2)


