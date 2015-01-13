%% detect_time: detect the time from a clock in an image I with a clock center at cx, cy and given radius
function [hours minutes] = detect_time(I)
figure;
imshow(I);
center = ginput(1);
edge = ginput(1);

cx = center(1);
cy = center(2);


ex = edge(1);
ey = edge(2);

radius = ((cx-ex)^2 + (cy-ey)^2)^.5;

[maxTheta bestThetas] = clock_hands(I, cx, cy, radius);

%Show the hand bounding boxes on the clock
O = I;
O = insertShape(O, 'Polygon', hand_boundary(cx, cy, radius, bestThetas(1,1)));
O = insertShape(O, 'Polygon', hand_boundary(cx, cy, radius, bestThetas(2,1)), 'Color', 'red');
imshow(O);

%The minute hand is usually detected the strongest, followed by the hour hand
thetaM = bestThetas(1,1);
thetaH = bestThetas(2,1);

[hours minutes] = time_from_angles(thetaH, thetaM);

end