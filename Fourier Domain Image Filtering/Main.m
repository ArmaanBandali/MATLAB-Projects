close all
M = 500;
N = 500;
u0 = [0,M/4,0,M/2,M/6,M/8];
v0 = [0,0,N/2,N/4,N/4,N/8];
xmaxfreq = [400,100,25,10];
ymaxfreq = [400,50,50,10];

figure
for i = 1:size(u0,2)
    subplot(2,3,i)
    imshow(uint8(cosineFunction(u0(i),v0(i),M,N)))
    title('u0= '+string(u0(i))+', v0= '+string(v0(i)))
end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
rectImg=uint8(rectangleFunction(M,N));
imshow(rectImg(1:M,1:N))
title('Figure 2. Image of Rectangle Function Centred at M/2,N,2 M=500, N=500')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure 
cosfft=abs(fft2(cosineFunction(u0(4),v0(4),M,N)));
surf(log10(cosfft+1))
title({'Figure 3. Log Scaled Fourier Transform', 'of 2D Cosine Function with M=100,N=100'})
xlabel('v frequency')
ylabel('u frequency')
zlabel('log10 amplitude')
figure
rectfft=fft2((rectangleFunction(M,N)));
surf(log10(abs(rectfft)+1));
title({'Figure 4. Log Scaled Fourier Transform', 'of Padded Rectangle Function with M=100,N=100'})
xlabel('v frequency')
ylabel('u frequency')
zlabel('log10 amplitude')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
cosfft=fftshift(cosfft);
surf(log10(cosfft+1))
title({'Figure 5. Log Scaled Zero-shifted Fourier Transform', 'of 2D Cosine Function with M=100,N=100'})
xlabel('v frequency')
ylabel('u frequency')
zlabel('log10 amplitude')
figure
rectfft=fftshift(rectfft);
surf(log10(abs(rectfft)+1))
title({'Figure 6. Log Scaled Zero-shifted Fourier Transform', 'of Rectangle Function with M=100,N=100'})
xlabel('v frequency')
ylabel('u frequency')
zlabel('log10 amplitude')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure
for i = 1:size(xmaxfreq,2)
    subplot(2,2,i)
    rectFiltered = uint8(ifft2(ifftshift(lowPassFilter(xmaxfreq(i),ymaxfreq(i),M,N))));
    imshow(real(rectFiltered(1:M,1:N)));
    title('v= '+string(xmaxfreq(i))+', u= '+string(ymaxfreq(i)))
end

        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I = imread('Images\SaturnRings.jpg');
J = double(I);
H = (J(:,:,1)+J(:,:,2)+J(:,:,3))/3; %Grayscale image by averaging RGB channels
width = size(H,2);
height = size(H,1);
pad = zeros(height,width);
padH = [H pad;pad pad];
exfft = (fftshift(fft2(padH)));

% exfftAbs = abs(exfft);
% exfftAbs=exfftAbs.*(255/max(exfft,[],'all'));
% figure
% imshow(uint8(exfftAbs))

for j=2:451
    minbound=278;
    maxbound=317;
    if (j > 225 && j < 229)
            continue
    elseif (j > 209 && j < 245)
        minbound=298;
        maxbound=306;
    end
    for i=minbound:maxbound
        exfft(j,i)=0;
    end
end

figure
recovered=uint8(ifft2(ifftshift(exfft)));
subplot(2,1,2)
imshow(real(recovered(1:height,1:width)))
title('Figure 8b. Fourier Domain Filtered Image of Saturn Rings')
subplot(2,1,1)
imshow(uint8(H))
title('Figure 8a. Periodic Noise Corrupted Image of Saturn Rings')





