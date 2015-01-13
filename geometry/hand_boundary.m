function bounding_rect = hand_boundary(cx, cy, radius, theta)
	phi = theta + pi/2; %perpendicular direction to the angle

	len = radius;
	width = .1*radius; %arbitrary width for the bounding rectangle

	centerPoint = [cx cy];
	endPoint = polar_add(centerPoint, len, theta);

	%bounding_rect has the format [x1 y1 x2 y2 x3 y3 x4 y4] for polygon drawing functions
	bounding_rect(1:2) = polar_add(endPoint, width, phi);
	bounding_rect(3:4) = polar_add(endPoint, -width, phi);
	bounding_rect(5:6) = polar_add(centerPoint, -width, phi);
	bounding_rect(7:8) = polar_add(centerPoint, width, phi);
end

%Adds a vector in the direction of theta (Theta in radians)
function new_vector = polar_add(vector, radius, theta)
	new_vector = vector + vec_from_polar(radius, theta);
end

function vector = vec_from_polar(radius, theta)
	vector = [radius*cos(theta) -radius*sin(theta)];
end