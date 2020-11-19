function kp = SSExtrema(DoGPyr)
%Finds keypoints (scalespace extrema) in 
%Difference of Gaussian pyramid representation of an image.  

%Input:
%DoGPyr is a MATLAB cell array of length noctaves containing 
%the Difference of Gaussian pyramid. 
%Each element of the array is a 3D array containing ns + 2 sub-octave DoG images
%This allows detection of DoG extrema over ns subband scales.

%Output:
%kp is a MATLAB cell array of length noctaves containing the detected
%keypoints.  Each element is itself a cell array over the ns subband
%scales.  Each element of this cell array consists of two fields max and min, 
%containing (x, y, val): the coordinates and values of the maxima and 
%minima within the subband.


   noctaves = length(DoGPyr);
   kp = cell(noctaves,1);
   % Looping over octaves
   for octave = 1:noctaves 
   oim = DoGPyr{octave};
   [h,w,s] = size(oim);
   % since we looking at groups of 3 the last 2 wont be considered.
   ns = s-2; 
   inkp_cell = cell(ns,1);
   %will contain neighbourhood images
   nghbrs = zeros([size(oim,1),size(oim,2),27]); 
    
   
   for nz = 1:ns % looping over subbands (ns)
      %Looking at 3 neighbourhoods
      oims = oim(:,:,nz:nz+2); 
      count = 1;
      
      % reshaping 3x3x3 points to a lenght 27 linear vector
      for i = -1:1
       for j = -1:1
       for k = -1:1
            imshifted = circshift(circshift(circshift(oims,i,1),j,2),k,3);
          nghbrs(:,:,count) = imshifted(:,:,2);
           count = count + 1;
        end
        end
      end   
      % finding the max amoung 27 neighbouring points along dimention 3 of nghbrs
       [M,INDX] = max(nghbrs, [],3,'includenan'); 
       
      % Grabbing the middle one (max is central pixel)
      res = M(INDX == 14); 
       [row,cal] = find(INDX == 14); 
       inkp_cell{nz}.max = [cal,row,res];
       
        % Grabbing the middle one (min is central pixel)
      [M,I] = min(nghbrs,[],3,'includenan');
       res = M(INDX == 14); 
       [row,cal] = find(INDX == 14);
       inkp_cell{nz}.min = [cal,row,res];
       
  end
    kp{octave} = inkp_cell;
    
   end
   
   
   
   
   
   
im = rgb2gray(imread('mondrian.jpg'));
s1 = 1.6;
ns = 3;
noctaves = 3;
GPyr = GSS(im,s1,ns,noctaves);
showPyr(GPyr,ns);
DoGPyr = DoGSS(GPyr);
showPyr(DoGPyr,ns);
kp = SSExtrema(DoGPyr);
showKP(DoGPyr,ns,kp,10);