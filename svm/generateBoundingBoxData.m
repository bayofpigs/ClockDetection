function thistruth = generateBoundingBoxData()
    Allsvm = dirAll('./mytrainedSVM/','*.mat');
    opt.conf_threshold =-0.8;
    for imageNum = 51:186
        if imageNum == 72 || imageNum == 89 || imageNum == 94 || imageNum == 138
            continue
        end

        try
            imageRgb = imread(sprintf('../images/data%03d.jpg', imageNum));
        catch exception 
            fprintf('Unable to read image %03d, continuing\n', imageNum);
            continue
        end

        fprintf('Processing %03d\n', imageNum);

        bb_2d_dAlldetector = TestingSingleImage_hog(imageRgb,Allsvm);
        % pick the bounding box has high confidence 
        bb_2d_dAlldetector_draw = bb_2d_dAlldetector(bb_2d_dAlldetector(:,end)>opt.conf_threshold ,:);
        bb_2d_dAlldetector_draw(:, 1:4)

        boxPosition{imageNum} = bb_2d_dAlldetector_draw(:, 1:4)
        number{imageNum} = imageNum;

        f = figure;
        draw_2d(imageRgb,bb_2d_dAlldetector_draw);
        drawnow;

        saveas(f,sprintf('./result/result-%03d.png',imageNum))
    end

    thistruth = struct('gtBb2d', boxPosition, 'imageNum', number)
end