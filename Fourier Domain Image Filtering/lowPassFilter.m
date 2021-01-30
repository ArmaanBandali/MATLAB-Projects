function [imageMatrix] = lowPassFilter(maxFreqX,maxFreqY, M, N)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
imageMatrix=fftshift(fft2(rectangleFunction(M,N)));
xbound=N-maxFreqX;
ybound=M-maxFreqY;
imageMatrix(1:ybound,1:2*N)=0;
imageMatrix(1:2*M,1:xbound)=0;
imageMatrix(2*M-ybound:2*M,1:2*N)=0;
imageMatrix(1:2*M,2*N-xbound:2*N)=0;

end

