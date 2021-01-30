close all
I = imread('Images\Nature.jpg.jfif');
J = double(I);
H = (J(:,:,1)+J(:,:,2)+J(:,:,3))/3; %Grayscale image by averaging RGB channels
width = size(H,2);
height = size(H,1);

histo = zeros(2,256); %Histogram of original image
histoEq = zeros(2,256); %Histogram of histogram equalized image
for i = 1:256 %allows a zero index to be used to represent intensities
    histo(2,i)=i-1;
    histoEq(2,i)=i-1;
end
H=uint8(H);
imgHistEqu=histeq(H,255); %Histogram equalization over 8 levels
for i = 1:width
    for j = 1:height %Counting number of pixels with respectiive intensities
                        %and storing in bins from 0-255
        intensity = H(j,i);
        histo(1,intensity+1)=histo(1,intensity+1)+1;
        intensity = imgHistEqu(j,i);
        histoEq(1,intensity+1)=histoEq(1,intensity+1)+1;
    end
end

figure
subplot(1,2,1)
bar(histo(2,:),histo(1,:))
title({'Figure 1a. Histogram of Pixel','Intensity Distributions in Unmodified Image'})
xlabel('Intensity')
ylabel('Number')
subplot(1,2,2)
bar(histoEq(2,:),histoEq(1,:))
title({'Figure 1b. Histogram of Pixel Intensity','Distributions in Histogram Equalized Image'})
xlabel('Intensity')
ylabel('Number')

figure
subplot (2,1,1)
imshow(imgHistEqu);
title({'Figure 2b. Histogram Equalized Grayscale Image'})
subplot(2,1,2)
imshow(H);
title({'Figure 2a. Unmodified Grayscale Image'})
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imgHistEqu = double(imgHistEqu);
fspec = abs(fft2(imgHistEqu)); %Magnitudes of Fourier Spectrum Coefficients

figure
subplot(1,2,1)
plot(fspec)
title({'Figure 3a. Fourier Spectrum of Histogram','Equalized Image'})
xlabel('Frequency (f)')
ylabel('Magnitude')
subplot(1,2,2)
logFspec = log10(fspec); %Log scaled magnitudes
plot(logFspec)
title({'Figure 3b. Logarithmic Fourier Spectrum of','Histogram Equalized Image'})
xlabel('Frequency (f)')
ylabel('log10(Magnitude)')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
imshow(convolutionMask(imgHistEqu,3)) %user defined convolutionMask function
%accepts a grayscale image matrix and desired kernel size
%returns kernel filtered grayscale uint8 image matrix
title({'Figure 4a. Smoothed Histogram Equalized','Image using 3x3 Kernel'})
figure
imshow(convolutionMask(imgHistEqu,9))
title({'Figure 4b. Smoothed Histogram Equalized','Image using 9x9 Kernel'})
figure
imshow(convolutionMask(imgHistEqu,15))
title({'Figure 4c. Smoothed Histogram Equalized','Image using 15x15 Kernel'})




















