%% time_from_angles: Return the time given two angles for the clock hands
function [hours minutes] = time_from_angles(thetaH, thetaM)
	thetaH = -(thetaH - pi/2);
	thetaM = -(thetaM - pi/2);

	minutes = (30/pi)*thetaM;
	minutes = mod(round(minutes), 60);
	hours = (6/pi)*thetaH - (1/60)*minutes;
	hours = mod(round(hours), 12);
end
