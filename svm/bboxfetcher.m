function thistruth = bboxfetcher()

  for i=1:6
    im = imread(sprintf('data2/image%02d.jpg', i));  
    imshow(im);  
    imp = impoly;
    pos = getPosition(imp);

    [pos(1, :), pos(3, :) - pos(1, :)]
    topLeft = pos(1, :);
    botRight = pos(3, :) - pos(1, :);
    boxPosition{i} = [topLeft, botRight];
    imageNum{i} = i;
  end

  thistruth = struct('gtBb2D', boxPosition, 'imageNum', imageNum)
end
