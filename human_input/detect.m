%% detect: drag rectangles to detect bounding boxes of clocks in the image
function [bboxes] = detect(image)

f = figure

imshow(image)

bboxes = []

while 1
	try
		bboxes = [bboxes; getrect]
	catch exception
		break
	end
end

end