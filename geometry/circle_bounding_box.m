%% circle_bounding_box: Returns a bounding box for the strongest detected circle in format [minX minY width height]
function [bbox] = circle_bounding_box(I)
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
for idx=0:(max_radius-10)/20
	[newCenters, newRadii, newMetric] = imfindcircles(I, [idx*20+10 idx*20+30], 'Method', 'TwoStage');
	centers = [centers; newCenters];
	radii = [radii; newRadii];
	metric = [metric; newMetric];

	[newCenters, newRadii, newMetric] = imfindcircles(I, [idx*20+10 idx*20+30], 'Method', 'TwoStage', 'ObjectPolarity', 'dark');
	centers = [centers; newCenters];
	radii = [radii; newRadii];
	metric = [metric; newMetric];
end

maxMetric = 0;
maxCenter = [];
maxRadius = 0;

for idx=1:length(metric)
	if metric(idx) > maxMetric
		maxMetric = metric(idx);
		maxCenter = centers(idx,:);
		maxRadius = radii(idx);
	end
end

minX = maxCenter(1) - maxRadius;
minY = maxCenter(2) - maxRadius;
width = 2*maxRadius;
height = 2*maxRadius;

bbox = [minX minY width height];

end
