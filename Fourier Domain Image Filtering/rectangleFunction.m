function [imageMatrix] = rectangleFunction(M,N)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
imageMatrix = zeros(M,N);
for i = 1:M
    for j = 1:N
        if i < 0.7*M && i > 0.3*M && j < 0.7*N && j > 0.3*N
            imageMatrix(i,j)=255;
        end
    end
end
padding = zeros(M,N);
imageMatrix = [imageMatrix, padding; padding,padding];
end

