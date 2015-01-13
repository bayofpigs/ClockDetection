%% showlines: function description
function [lines] = showlines(filename)

I = rgb2gray(imread(filename));
BW = edge(I, 'canny');
[H,T,R] = hough(BW);
P = houghpeaks(H, 5);
lines = houghlines(BW, T, R, P, 'MinLength', 20);

figure; imshow(I); hold on;

for k = 1:length(lines)
   xy = [lines(k).point1; lines(k).point2];
   plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

   % Plot beginnings and ends of lines
   plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
   plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
end

end