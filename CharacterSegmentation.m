function number = CharacterSegmentation(image)
%u = imread(image);
u = image;
imagen =~imbinarize(u);
%%Remove all object containing fewer than 40 pixels
imagen = bwareaopen(imagen,40);
[L Ne]=bwlabel(imagen);
props = regionprops(L,'Area','BoundingBox','PixelList');
k=0;
% D = 'C:\\Users\\SUNIL KUMAR\\Downloads\\Matlab\\PhotoOCRproject';
% F = 'Characters segmented';
% Z = fullfile(D,F,sprintf('%s',imgName));
% if ~exist(Z,'dir')
%    mkdir(Z)
% end
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
        character = imbinarize(character);
%         FileName = fullfile(Z, sprintf('%d.jpg',k));
%         imwrite(character,FileName);
        nu = NumberRecognition(character);
        number = [number,nu];
        end
    end
end
end