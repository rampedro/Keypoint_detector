%clc, clear, close all;
%GPyr_gt = load('Gpyr.mat');
%GPyr_gt = GPyr_gt.GPyr;
im = imread('mondrian_gray.jpg');
%s1 = 1.6;
%ns = 3;
%noctaves = 3;
%GPyr_our = GSS(im, s1, ns, noctaves);
%showPyr(GPyr_gt,ns);
%showPyr(GPyr_our,ns);
%cell1_gt = GPyr_gt{2};
%image1_gt = cell1_gt(:, :, 5);
%cell1 = GPyr_our{2};
%image1 = cell1(:, :, 5);

%%
%function GPyr = GSS(im, s1, ns, noctaves)
%Creates a Gaussian pyramid representation of an image.  

%Input:
%im:        The input image
%s1:        Base scale constant  
%ns:        Number of sub-octave scales
%noctaves   Number of octaves

%Output:
%GPyr is a MATLAB cell array of length noctaves containing the Gaussian pyramid. 
%Each element of the array is a 3D array containing ns + 3 sub-octave images
%This allows computation of ns + 2 DoG images, and thus detection of ns
%extrema of DoG features over scale.


noctaves = 3;
variance = 0;
count = 0;
s = s1;
counter = 1;
inherited_sigma = 1;
k = 2^(1/(ns));
Ss = zeros((ns+3)*noctaves,1, 'double');

    
GPyr = cell(noctaves,1);




%%Generating the Pyramid

s = s1;
[h w]= size(im);
l = zeros(h,w);


   

%% Calculating the fist Octove
 
for j=1:ns+3
    
   s
    
    m = ceil(sqrt(-2*s*s*log(1/100)));
    x = [-m:m];
    h = exp(-x.^2/(2*s^2));
    h = h/sum(h(:));

    if j == 1
       g1 = conv2(h,h,im,'same');
    else
       g1 = conv2(h,h,g1,'same');
    end
    
    if j <2
        s = s*sqrt((k^2)-1);
    else
        s = s*k;
    end
    
    
    % Store them
    
    if l~=zeros()
    l = cat(3,l,g1);
    else
    l = g1;
    end
  
end

GPyr(1) = {l};




%%Rest of Octoves and their suboctoves

%s= s1;

for i=2:noctaves

   im = im(1:2:end,1:2:end);
    [h w]= size(im);
    l = zeros(h,w);
    

  for j=1:ns+3

      %% First Three are inherited from Previous octove
      
   if j<=3
         
       pre = ns+j;
       previousOctv = GPyr{i-1,1}(:,:,pre);
       GPyr{i,1}(:,:,j) =  previousOctv(1:2:end,1:2:end);
       %imresize(GPyr{i-1,1}(:,:,j),0.5);
       
 
    else
          
     s = sqrt((k^2)-1)*(k^(j-2))*s1
     
     
    m = ceil(sqrt(-2*s*s*log(1/100)));
    x = [-m:m];
    h = exp(-x.^2/(2*s^2));
    h = h/sum(h(:));
    
    gPre = GPyr{i,1}(:,:,j-1);
    
    g1 = conv2(h,h,gPre,'same');
    
    
  

    
    
    GPyr{i,1}(:,:,j) = g1;
          
    

    

    end
    
    

  end
  

  
  
end

noctave = length(GPyr);
c = 1;
s1 = 1.6;

for octave = 1:noctave
   oim = GPyr{octave};
   n = size(oim,3);
    h = 0;
    for suboctave = 1:n
       img = oim(:,:,suboctave);
  
        
       margin = round(s1*(k^(h)))
       
        img(1:margin,:) = "NaNs";
        img(:,1:margin) = "NaNs";

        img(end-margin+1:end,:) = "NaNs";
        img(:,end-margin+1:end) = "NaNs";
        
        oim(:,:,suboctave) = img;


       c = c + 1;
       h = h + 1;
       
    end
    
    
    GPyr{octave} = oim;
    
end
%end



%Display Pyramid representation of image, with ns subband scales per octave
noctave = length(GPyr);
k = 2^(1/ns);

figure;
p = 1;
for octave = 1:noctave
   oim = GPyr{octave};
   n = size(oim,3);
    for suboctave = 1:n
       subplot(noctave,n,p);
       imagesc(oim(:,:,suboctave));axis image;axis off;colormap gray;
       title(sprintf('Scale = %0.1f',2^(octave-1)*k^(suboctave - 1)),'FontSize',10);
       p = p + 1;
   end
end