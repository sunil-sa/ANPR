clear all
clc
%Reading the image 
img = imread('P1010003.jpg');
figure('Renderer', 'painters', 'Position', [10 10 1300 750])
subplot(4,2,1)
imshow(img)
title('Original image')
%Selecting the lower half region for further usage 
img1 = img(200:end,1:end,3);
subplot(4,2,2)
imshow(img1)
title('Cropped image')
%PART1 NUMBER PLATE DETECTION(using Mathematical Morphology)
%detecting the edges using sobel operator
img_edge = edge(img1,'Sobel');
subplot(4,2,3)
imshow(img_edge)
title('Image after detecting edges using sobel operator')
%dilating the image
se1 = strel('line',2,90);
img_vdil = imdilate(img_edge,se1);
se2 = strel('line',2,0);
img_hdil = imdilate(img_vdil,se2);
subplot(4,2,4)
imshow(img_hdil)
title('Dilated image')
%Filling the holes in the binarized image
img_filled = imfill(img_hdil,'holes');
subplot(4,2,5)
imshow(img_filled)
title("Image after filling the holes")
%Clearing the objects connected to the border of the image
img_clrborder = imclearborder(img_filled);
subplot(4,2,6)
imshow(img_clrborder)
title("Image after removing the connected objects on border")
%Selecting the object which is filled and has maximum area
props = regionprops(img_clrborder,'Area','PixelList');
max_area = props(1).Area;
max_count = 1;
for count=1:size(props,1)
    if(max_area < props(count).Area)
        max_area = props(count).Area;
        max_count = count;
    end
end
    out_img = zeros([size(img_edge,1) size(img_edge,2)]);
    pixels = props(max_count).PixelList;
    for count=1:size(pixels,1)
        out_img(pixels(count,2),pixels(count,1)) = 1;
    end
     maxi = max(pixels,[],1);
     mini = min(pixels,[],1);
     txt = img1(mini(2):maxi(2),mini(1):maxi(1));
 subplot(4,2,7)
 imshow(txt)
 title("The extracted Number plate image")
 %PART 2 AND 3 (CHARACTER SEGMENTATION AND CHARACTER RECOGNITION)
 u = txt;
imagen =~imbinarize(u);
%%Remove all object containing fewer than 40 pixels
imagen = bwareaopen(imagen,40);
[L Ne]=bwlabel(imagen);
%Using boundingbox method for finding the characters
props = regionprops(L,'Area','BoundingBox','PixelList');
subplot(4,2,8)
imshow(~imagen)
title("Boxes over characters")
for i=1:length(props)
    box=props(i).BoundingBox;
        if(box(4)>box(3))   %controlling height of each bounding boxes   
                rectangle('Position',box,'EdgeColor','g','LineWidth',2);
        end
end
k=0;
p=0;
number = [];
for n=1:Ne
    BB = props(n).BoundingBox;
    area = props(n).Area;
    if(BB(4)>BB(3))
        if((BB(4)/BB(3))<1.35 & area<100)
            p = p+1;
        else
        k = k+1;
        [r,c] = find(L==n);
        character=u(min(r):max(r),min(c):max(c));
        %After finding each character NumberRecognition func is called
        %which returns the predicted character 
        character = imbinarize(character);
        nu = NumberRecognition(character);
        number = [number,nu];
        end
    end
end
fprintf("Found vehicle number is: %s\n",number)
speakout(number)