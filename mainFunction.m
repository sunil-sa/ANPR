clear all
clc
%PART1(PLATE DETECTION)
imds=imageDatastore('car images dataset','IncludeSubfolders',1,'LabelSource','foldernames');
imagTot=length(imds.Files);
 for j=1:imagTot
 [i,fileinfo] = readimage(imds,j);
 x = fileinfo.Filename;
 text = detectText(i);
 FileName = sprintf('C:\\Users\\SUNIL KUMAR\\Downloads\\Matlab\\ANPR Project\\Numberplates\\%s',x(71:end));
 imwrite(text,FileName);
 end
%PART2(CHARACTER SEGMENTATION + CHARACTER RECOGNITION)
 imds1=imageDatastore('Numberplates','IncludeSubfolders',1,'LabelSource','foldernames');
 imagTot1=length(imds1.Files);
 Numbers={};
 for j=1:imagTot1
     [i,fileinfo] = readimage(imds1,j);
     number = CharacterSegmentation(i);
     if length(number)==0
         Numbers{j} = '0';
     else
     Numbers{j} = number;
      end
 end
 %Finding total number of correctly found vehicle numbers
 count=0;
 count1=0;
 load('VehicleNumbers.mat')
 Vnum = numbers;
 correct=[];
 for n = 1:length(Numbers)
     r = cell2mat(Vnum(n));
     l = cell2mat(Numbers(n));
     if length(r)~=length(l)
         count1=count1+1;
     elseif r==l
           count=count+1;
           correct = [correct;n];
     end
 end
 fprintf("Total number of Vehicle numbers found correct are: %d\n",count); 
             
     