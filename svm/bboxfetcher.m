function thistruth = bboxfetcher()

  for i=51:186
    if i == 72 || i == 89 || i == 94 || i == 138
      continue
    end

    try
      imageRgb = imread(sprintf('../images/data%03d.jpg', i));
    catch exception 
      fprintf('Unable to read image %03d, continuing\n', i);
      continue
    end

    im = imread(sprintf('../images/data%03d.jpg', i));  
    imshow(im);  

    % The bounding box must be listed as 
    % 1. topleft corner
    % 2. the height and the width

    bboxes = []

    while 1
      try
        bboxes = [bboxes; getrect]
      catch exception
        break
      end
    end
    boxPosition{i} = bboxes;
    imageNum{i} = i;
  end

  thistruth = struct('gtBb2D', boxPosition, 'imageNum', imageNum)
end
