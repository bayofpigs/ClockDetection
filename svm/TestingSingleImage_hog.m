function bb_2d_dAlldetector = TestingSingleImage_hog(imageRgb,Allsvm)
bb_2d_dAlldetector = [];
for modelid =1:length(Allsvm)
    load(Allsvm{modelid},'Model');
    [bbdet] = testfeaturePym(imageRgb, Model);
    bb_2d_dAlldetector = [bb_2d_dAlldetector;bbdet];
end
% non-maximum spression among all detectors 
indexes = nmsMe(bb_2d_dAlldetector, 0.5); 
bb_2d_dAlldetector = bb_2d_dAlldetector(indexes,:);
end
