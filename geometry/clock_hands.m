%% clock_hands: Finds clock hands on image i for a clock face with center (cx, cy) and given radius
function [maxTheta bestThetas] = clock_hands(I, cx, cy, radius)

	%Get the gradient magnitudes and directions (in radians)
	[magnitude, direction] = imgradient(rgb2gray(I));
	direction = direction * (pi/180);
	maxFlux = 0;
	maxTheta = 0;
	thetas = [];
	for i = 1:100
		theta = 2*pi*i/100;
		flux = gradient_sum(I, magnitude, direction, cx, cy, radius, theta);
		thetas = [thetas;theta flux];
		if flux > maxFlux
			maxFlux = flux;
			maxTheta = theta;
		end
	end

	%find the best thetas
	bestThetas = [];
	cutoff = .75;
	while size(bestThetas,1) < 2
		bestThetas = non_maximum_supression(thetas, cutoff);
		cutoff = cutoff * .9;
	end

	%sort thetas based on the score
	bestThetas = sortrows(bestThetas, -2);
	bestThetas(:,1)


end

function bestThetas = non_maximum_supression(thetas, cutoff)
	bestThetas = [];
	maxFlux = max(thetas(:,2));
	maxTheta = 0;

	%1. Threshold at cutoff% * the maximum
	for i = 1:100
		if thetas(i,2) < cutoff*maxFlux
			thetas(i,2) = 0;
		end
	end
	
	maxFlux = 0;
	%2. Do non-maximum supression to find the best thetas
	for i = 1:100
		if thetas(i,2) == 0
			if maxFlux ~= 0
				bestThetas = [bestThetas; [maxTheta maxFlux]];
			end
			maxFlux = 0;
		elseif thetas(i,2) > maxFlux
			maxFlux = thetas(i,2);
			maxTheta = thetas(i,1);
		end
	end
end

%Sum up the absolute value of gradients supporting the hypothesis of a hand pointing at angle theta
function flux = gradient_sum(I, magnitude, direction, cx, cy, radius, theta)
	bounding_rect = hand_boundary(cx, cy, radius, theta);

	%Get a mask of coordinates that lie within the bounding rectangle
	mask = poly2mask(bounding_rect([1 3 5 7]), bounding_rect([2 4 6 8]), size(I,1), size(I,2));

	flux = 0;
	for i = 1:size(I,1)
		for j = 1:size(I,2)
			if mask(i,j)
				flux = flux + abs(magnitude(i,j) * sin(direction(i,j)-theta));
			end
		end
	end
end
