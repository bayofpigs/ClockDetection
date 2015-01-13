%% display: function description
function [centers, radii, metric] = display_stuff(image_filename)

I = imread(image_filename);

%try circle detection on a variety of scales for the radius
max_diameter = min(size(I,1), size(I,1));
max_radius = max_diameter / 2;

%centers: x y coordinates of circle centers
centers = [];
%radii: radii of the circles
radii = [];
%metric: scoring metric of how good the circle match was
metric = [];

%use 20 pixel increments from 10px up to max_radius
for i=0:(max_radius-10)/20
	[newCenters, newRadii, newMetric] = imfindcircles(I, [i*20+10 i*20+30], 'Method', 'TwoStage');
	centers = [centers; newCenters];
	radii = [radii; newRadii];
	metric = [metric; newMetric];

	[newCenters, newRadii, newMetric] = imfindcircles(I, [i*20+10 i*20+30], 'Method', 'TwoStage', 'ObjectPolarity', 'dark');
	centers = [centers; newCenters];
	radii = [radii; newRadii];
	metric = [metric; newMetric];
end

%display the circles on the image
figure, imshow(I);
viscircles(centers, radii);

%display the canny edge detection of the image
BW = rgb2gray(I);
E = edge(BW, 'canny');
figure, imshow(E);

clock_hands(I, centers(1,1), centers(1,2), radii(1));

end


% params.minAspectRatio = .7

% % note that the edge (or gradient) image is used
% bestFits = ellipseDetection(E, params);
% figure;
% image(I);
% %ellipse drawing implementation: http://www.mathworks.com/matlabcentral/fileexchange/289 
% ellipse(bestFits(:,3),bestFits(:,4),bestFits(:,5)*pi/180,bestFits(:,1),bestFits(:,2),'k');