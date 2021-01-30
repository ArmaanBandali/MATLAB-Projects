% close all
I = imread('Images\Capture2.jpg');
J = double(I);
H = (J(:,:,1)+J(:,:,2)+J(:,:,3))/3; %Grayscale image by averaging RGB channels

Z=zeros(h,w);
h = size(H,1);
w = size(H,2);

for j=1:w
    for i=1:h
        y = sqrt(i^2 + j^2);
        if y > w
            y = w;
        end
        if y < 1
            y = 1;
        end
        x = ((2*h)/pi)*atan(j/i);
        if x > h
            x = h;
        end
        if x < 1
            x = 1;
        end
        Z(j,i)=H(round(x),round(y));
    end
end

Z = rot90(Z);

Z = uint8(Z);
H = uint8(H); %Conversion from double back to uint8 before using imshow

figure
imshow(Z)