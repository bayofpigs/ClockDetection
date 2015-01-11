% load all GT
% CODE REPLACED FOR EC
%load('groundTruthBbs.mat');
load('groundTruthBbs2.mat');

addpath(genpath('.'))
opt.numOfNegimage = 6;
opt.NumOfNexLimit =1000;
opt.maxiter = 3;
opt.conf_threshold =-0.8;
opt.conf_thresholdvis =-0.71;
opt.train = 1;
opt.test = 1;
Outputpath = './trainedSVM/';
replace = 0;

if opt.train 
    % training 3 examplar 
    Outputpath = './mytrainedSVM/';
    mkdir(Outputpath);
    for imageNumPos =1:opt.numOfNegimage
        TrainingMain_hog(imageNumPos,groundTruthBbs,Outputpath,opt,replace);
    end
end

if opt.test
    % testing on the testing image
    Allsvm = dirAll(Outputpath,'*.mat');
    for imageNum =opt.numOfNegimage+1:18
        % detect 

        % CODE REPLACED FOR EC
        %imageRgb = imread(sprintf('./data/image%02d.jpg',imageNum));
        imageRgb = imread(sprintf('./data2/image%02d.jpg',imageNum));


        bb_2d_dAlldetector = TestingSingleImage_hog(imageRgb,Allsvm);
        % pick the bounding box has high confidence 
        bb_2d_dAlldetector_draw = bb_2d_dAlldetector(bb_2d_dAlldetector(:,end)>opt.conf_threshold ,:);
        bb_2d_dAlldetector_draw
        % draw result
        f = figure;
        draw_2d(imageRgb,bb_2d_dAlldetector_draw);
        drawnow;
        
        saveas(f,sprintf('./result/result-%03d.png',imageNum))
    end
end


