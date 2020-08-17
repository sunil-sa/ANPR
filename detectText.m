function[txt] = detectText(img)
img1 = img(200:end,1:end,3);
%img1 = rgb2gray(img1);
img_edge = edge(img1,'Sobel');
se1 = strel('line',2,90);
img_vdil = imdilate(img_edge,se1);
se2 = strel('line',2,0);
img_hdil = imdilate(img_vdil,se2);
img_filled = imfill(img_hdil,'holes');
img_clrborder = imclearborder(img_filled);
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
 end