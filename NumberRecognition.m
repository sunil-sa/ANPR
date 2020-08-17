function nu = NumberRecognition(Number)
load('Weights.mat')
Number = imresize(Number,[20,20]);
Number = im2double(Number);
Number = Number(:);
nu = predict(Theta1,Theta2,Number');
end