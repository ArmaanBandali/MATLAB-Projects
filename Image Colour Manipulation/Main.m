%Armaan Bandali
%%%%%%%%%%%%%%%%
% Question 1
% syms z(x,y) x y;
% z(x,y) = sin(sqrt((x-227)^2+(y-127)^2))/sqrt((x-227)^2+(y-127)^2); %2D sinc function shifted
% 
% figure
% fsurf(z,[0,355]) %specify maximum of x and y
% title('Figure 1-1a. 2D sinc function centred at (227, 127)')
% xlabel('x')
% ylabel('y')
% zlabel('amplitude, z')
% axis([100 355 0 255 -1 1]) %readjust axes so 100<x<355 and 0<y<255 and -1<z<1
% 
% figure
% colormap('gray') %grayscale
% fsurf(z,[0,355])
% title('Figure 1-1b. 2D grayscale sinc function centred at (227, 127)')
% xlabel('x')
% ylabel('y')
% zlabel('amplitude, z')
% axis([100 355 0 255 -1 1])
%%%%%%%%%%%%%%%%%
%Question 2

I = imread('Images\Capture.jpg'); %image to be analyzed
J = double(I); %conversion from uint8 to double

numRows = size(I,1);
numColumns = size(I,2);

r = zeros(numRows, numColumns, 3, 'uint8'); % Red channel
g = zeros(numRows, numColumns, 3, 'uint8'); % Green channel
b = zeros(numRows, numColumns, 3, 'uint8'); % Blue channel

r(:,:,1) = I(:,:,1); %Adding red values from image
g(:,:,2) = I(:,:,2); %Adding green values from image
b(:,:,3) = I(:,:,3); %Adding blue values from image

figure
subplot(2,2,1)
imshow(r)
title('Figure 1-2a. Red Channel');
subplot(2,2,2)
imshow(g)
title('Figure 1-2b. Green Channel');
subplot(2,2,3)
imshow(b)
title('Figure 1-2c. Blue Channel');
subplot(2,2,4)
imshow(I)
title('Figure 1-2d. Original Image');

%%%%%%%%%%%%%%%%%
%Question 3

H = (J(:,:,1)+J(:,:,2)+J(:,:,3))/3; %Grayscale image by averaging RGB channels
H = uint8(H); %Conversion from double back to uint8 before using imshow
figure
imshow(H)
title('Figure 1-3. Grayscale Image Produced by Averaging Colour Channels')

%%%%%%%%%%%%%%%%%
%Question 4
figure
colormap 'gray' 
surf(H) %Surface plot of z-value intensities of H as height
title('Figure 1-4. Grayscale Surface Plot of Image Intensities')
xlabel('x')
ylabel('y')
zlabel('Intensity')

%%%%%%%%%%%%%%%%%
%Question 5
for iterX = 1:size(H,1)
    for iterY = 1:size(H,2)
        if H(iterX,iterY) < 129 %Only keeping intensities greater than 128
            H(iterX,iterY)=0;
        end
    end
end

figure
colormap 'gray'
surf(H) %Surface plot of grayscale intensities greater than 128
        %Removed values show up as black at z=0
title('Figure 1-5. Grayscale Surface Plot of Image Intensities Greater than 128')
xlabel('x')
ylabel('y')
zlabel('Intensity')
        
      








