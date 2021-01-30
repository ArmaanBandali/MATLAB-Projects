function [imageMatrix] = cosineFunction(u0,v0, M, N)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
imageMatrix = zeros(M,N);
for i = 1:M
    for j = 1:N
        imageMatrix(i,j)=cos(2*pi*(((u0*j)/M)+((v0*i)/N)));
    end
end
A = 255/max(imageMatrix,[],'all');
imageMatrix = imageMatrix.*A;

end