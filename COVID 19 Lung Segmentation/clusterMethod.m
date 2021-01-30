function [cluster,difference,kValues] = clusterMethod(img,kMeansClust)
%This function applies Matlab's cluster segmentation algorithm to an image
%to produce kMeansClust number of clusters. The returned cluster shows the
%covid-affected lung tissue. All clusters and the segmentation can be seen
%individually as well. Methods and code here rely heavily on code from [2]


imgLab=zeros(size(img,1),size(img,2),3);
imgLab(:,:,1)=img;
imgLab(:,:,2)=img;
imgLab(:,:,3)=img; 
ab = imgLab(:,:,2:3); %extract colour values, [6] in reference
ab = im2single(ab); %grayscale

% repeat the clustering 3 times to avoid local minima
pixel_labels = imsegkmeans(ab,kMeansClust,'NumAttempts',3); %%%%%%%%%%
figure
subplot(2,2,1)
imshow(pixel_labels,[]) %clustered image
title({'Figure 5a. Cluster Segmentation of Isolated Lungs'})

mask1 = pixel_labels==1; %first cluster
mask2 = pixel_labels==2; %second cluster
mask3 = pixel_labels==3; %third cluster
clusters = {img.*uint8(mask1),img.*uint8(mask2),img.*uint8(mask3)}; %apply cluster mask to image to isolate clusters
avgIntensities = {mean2(img.*uint8(mask1)),mean2(img.*uint8(mask2)),mean2(img.*uint8(mask3))}; %get the average intensity of each cluster mask


subplot(2,2,2)
imshow(clusters{1,1})
title({'Figure 5b. Cluster with Label=1'})

subplot(2,2,3)
imshow(clusters{1,2})
title({'Figure 5a. Cluster with Label=2'})

subplot(2,2,4)
imshow(clusters{1,3})
title({'Figure 5a. Cluster with Label=3'})
targetK=0; %covid cluster will have intensity between normal lung tissue cluster and background
kValues=zeros(2);
kCount=1;
for k=1:3
    if avgIntensities{1,k}==0
        continue
    else
        kValues(kCount)=k;
        kCount=kCount+1;
    end
    if targetK==0
        targetK=k;
        continue
    end
    if avgIntensities{1,k}<avgIntensities{1,targetK}
        targetK=k;
    end
end
difference=abs(avgIntensities{1,kValues(1)}-avgIntensities{1,kValues(2)});

cluster=clusters{1,targetK}; %covid cluster
end

