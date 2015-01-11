function [ bbdet ] = testfeaturePym(imageRgb,Model )
%evaluste the image by conv it with template and output high conf bounding
% Input :
% imageRgb: color image 
% Model: trained model
% Output :
% bbdet:
% each row stores one detection box in the format of [x1,y1,x2,y2,detection_score]
% x1 y1 is the top left corners of the box
% x2 y2 is the bottom right corners of the box

% get the weight and bias
weight = Model.svm.w;
b0 =  Model.svm.bias;

% Step 1: get image pyramid using function : feature_pyramid
featurePym = feature_pyramid(imageRgb);

%% Setp 2: convolution
bbdet = [];
for level=1:length(featurePym.feat)
    % for each level of the feature pyramid 
    if sum(size(featurePym.feat{level})<size(weight))>0,
        break;
    end

    % do convlusion using fconv
    % adding bias (matchscore = matchscore + b0)
    score = fconv(featurePym.feat{level}, {weight}, 1, 1);
    matchscore = score{1};
    matchscore = matchscore + b0;

    % obtain window  top right corners in feature cordinate
   
    % Get the bbs width and height from size of weight
    % Translate to orginal image cordinate from feature cordinate 
    % Hints : Each HoG cell has 8 pixels, image is resize to featurePym.scale(level)     
    %{
    fprintf('featsize 1,2=%d,%d ; matchscore 1,2=%d,%d ; weight 1,2=%d,%d\n', ...
      size(featurePym.feat{level}, 1), size(featurePym.feat{level}, 2),...
      size(matchscore, 1), size(matchscore, 2), size(weight, 1), size(weight, 2));
    %}
    running = [];
    for x=1:size(matchscore, 1)
      for y=1:size(matchscore, 2)
        %(x - 1) * size(matchscore, 1) + y
        scale = featurePym.scale(level);
        topleft = [x, y] .* 8 ./ scale;
        bottomright = [(x + size(weight, 1) - 1), (y + size(weight, 2) - 1)] .* 8 ./ scale;
        running((x - 1) * size(matchscore, 1) + y, :) = ...
          [topleft(2), topleft(1), bottomright(2), bottomright(1), matchscore(x, y)];
      end
    end
    % Remove zero rows
    running(all(running == 0,2),:) = [];
    bbs{level} = running;

    % store all the boxes for each level  in the format of 
    % [topx,topy, botrightX, botrightY, detection_score]
    bbdet = [bbdet; bbs{level}]; 
end

%% Setp 3:  do Non-maximum suppression using : nmsMe, with 0.5 as overlap threshold
nmsMe(bbdet, .5);

end

