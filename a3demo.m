function a3demo(im)
%Demonstration code for Assignment 3

s1 = 1.6; %Space constant of Gaussian kernel applied to first (base) level 
          %of each octave of the pyramid
ns = 3; %Number of subband scales
noctaves = 3; %Number of octaves to represent

GPyr = GSS(im,s1,ns,noctaves);

showPyr(GPyr,ns);
DoGPyr = DoGSS(GPyr);
showPyr(DoGPyr,ns);
kp = SSExtrema(DoGPyr);

nkp = 10; %Number of top keypoints to show
showKP(DoGPyr,ns,kp, nkp);