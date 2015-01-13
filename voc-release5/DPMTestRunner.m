
addpath(genpath('.'));
load 2012/clock_final.mat;
for i=114:186
  if i == 72 || i == 89 || i == 94 || i == 138
      continue
  end

  try
      imageRgb = imread(sprintf('../images/data%03d.jpg', i));
  catch exception 
      fprintf('Unable to read image %03d, continuing\n', i);
      continue
  end

  % Use threshold of -1. Clock detection recommends -.883
  fprintf('appling process to image %03d\n', i)
  bbox = process(imageRgb, model, -1);

  f = showboxes(imageRgb, bbox);
  drawnow;
  saveas(f,sprintf('./result/result-%03d.png',i));
end