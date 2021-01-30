function [logKernel] = lapGauKernel()
%This function calculates and returns the Laplacian of Gaussian kernel to
%be convolved in laplacianEdge(). The Gaussian kernel smooths the image to
%remove fast changes in the image that the Laplacian would amplify. The
%discretization of the kernel is obtained by integrating the equation
%between integers, rather than just applying the equation to the exact
%integer.

logKernel=zeros(9,9);
stdd=0.2; %stdd can be changed to detect finer edges, or increased to get coarse edges
f=@(x,y)(-1/(pi*stdd^4)).*(1-((x.^2+y.^2)./(2*stdd^2))).*exp(-1.*(x.^2+y.^2)./(2*stdd^2));
%[4] in references
for i=-4:4
    for j=-4:4
        logKernel(j+5,i+5)=integral2(f,i-0.5,i+0.5,j-0.5,j+0.5); %integrate f over entire pixel to get weights
    end
end
logKernel=(logKernel.*(-40/logKernel(5,5))); %normalization of kernel values

end

