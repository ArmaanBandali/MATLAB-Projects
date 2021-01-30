close all
I = imread('Images\TestSet1\Patient001.jpg');
J = double(I);
H = (J(:,:,1)+J(:,:,2)+J(:,:,3))/3; %Grayscale image by averaging RGB channels

width = size(H,2);
height = size(H,1);
sz=[height width];

figure
imshow(uint8(H));
title({'Figure 8. Grayscale CT Scan of Patient010 Lungs'})


binImg = imcomplement(otsuMethod(H)); %Inverted binarized image
figure
imshow(binImg)
title({'Figure 2. Inverted Binary Image of Patient001 Lungs'})

H=uint8(H);
img=lungsIsolation(binImg); %Extract pixel positions of lungs and only show those pixels
for i=1:width
    for j=1:height
        if img(j,i)==0
            H(j,i)=255; %Label all other pixels as white
        end
    end
end

figure
imshow(H) %isolated lungs image
title({'Figure 4. Isolated Lungs'})
[H3,difference,kValues]=clusterMethod(imcomplement(uint8(H)),3); %cluster segmentation of lungs in 3 colours
                                            %imcomplement used to swap
                                            %lungs to foreground
H4=laplacianEdge(H); %calculate the edges of isolated lung image
figure
covidSegment=H3-uint8(H4); %enhance segmented covid sections by subtracting edges
percentAffected=numel(find(covidSegment))/numel(find(imcomplement(H)))*100;
differenceMetric=0;
subplot(1,2,1)
imshow(uint8(H))
title({('Figure 7a. Original CT Scan'),('of Patient001 Lungs')})
subplot(1,2,2)
imshow(covidSegment)
title({('Figure 7b. COVID-19'),('Cluster = '+string(percentAffected)+'% Infected Tissue'),('Difference = '+string(difference)+' ,Label= '+string(kValues(1,1))+','+string(kValues(2,1)))})
