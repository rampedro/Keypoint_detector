function DoGPyr = DoGSS(GPyr)
%Creates a Difference of Gaussian pyramid representation of an image.  

%Input:
%GPyr is a MATLAB cell array of length noctaves containing the Gaussian pyramid. 
%Each element of the array is a 3D array containing ns + 3 sub-octave
%images, where ns is the number of sub-band scales sampled per octave.
%This allows computation of ns + 2 DoG images, and thus detection of ns
%extrema of DoG features over scale.

%Output:
%DoGPyr is a MATLAB cell array of length noctaves containing 
%the Difference of Gaussian pyramid. 
%Each element of the array is a 3D array containing ns + 2 sub-octave DoG images
%This will allow detection of ns extrema of DoG features over scale.

 noctaves = length(GPyr);
 DoGPyr = cell(noctaves,1);
 
 for i = 1:3
     temp = GPyr{i};
     DoGPyr{i} = diff(temp,1,3);
 end


 
 im = rgb2gray(imread('mondrian.jpg'));
s1 = 1.6;
ns = 3;
noctaves = 3;
GPyr = GSS(im,s1,ns,noctaves);
showPyr(GPyr,ns);
DoGPyr = DoGSS(GPyr);
showPyr(DoGPyr,ns);