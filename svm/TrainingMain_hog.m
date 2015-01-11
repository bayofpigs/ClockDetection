function  TrainingMain_hog(imageNumPos,groundTruthBbs,Outputpath,opt,replace)

Modeltosavefullpath = sprintf('%s/TrainedModel%02d.mat',Outputpath,imageNumPos);%[Outputpath '/' num2str(imageNumPos) '.mat'];
if exist(Modeltosavefullpath,'file')&& ~replace
    fprintf('skip training model: %s\n.',Modeltosavefullpath);  
else
    %% gen Pos
    BB = groundTruthBbs([groundTruthBbs.imageNum]==imageNumPos);
    BB = round(BB.gtBb2D);

    % CODE REPLACED FOR EXTRA CREDIT
    %imageRgb = imread(sprintf('./data/image%02d.jpg',imageNumPos)); 
    imageRgb = imread(sprintf('./data2/image%02d.jpg',imageNumPos)); 

    featurePym = feature_pyramid(imageRgb);
    [Pos_all,size_pos] = getTemplate(featurePym, [BB(1),BB(2),BB(1)+BB(3),BB(2)+BB(4)]);
    pos = reshape(Pos_all,size_pos);
    figure,
    subplot(1,2,1)
    imshow(imageRgb(BB(2):BB(2)+BB(4),BB(1):BB(1)+BB(3),:))
    subplot(1,2,2)
    showHOG(pos);
    title('The postive examplar')
    
    Model.posRgb = imageRgb(BB(2):BB(2)+BB(4),BB(1):BB(1)+BB(3),:);
    Model.posfeature = pos;
    
    fprintf('Start training model: \n %s\n.',Modeltosavefullpath);  
    tic
    % random generate positive 
    randNegAll =[];
    for ii =1:opt.numOfNegimage
       imageNum = ii;

       % CODE REPLACED FOR EXTRA CREDIT
       %imageRgb = imread(sprintf('./data/image%02d.jpg',imageNum));
       imageRgb = imread(sprintf('./data2/image%02d.jpg',imageNum));

       featureNeg = feature_pyramid(imageRgb);
       postive_bb = groundTruthBbs([groundTruthBbs.imageNum]==imageNum);
       %random generate 1000 negatives from each image
       [randNeg,~] = hogGenerateNex( postive_bb,featureNeg,size_pos,1000);
       randNegAll =[randNegAll,randNeg];
    end
    t=toc;
    NumNex =size(randNegAll,2);
    fprintf('Random gen Negs take: %f\n NegSVM first taining start !\n NegAll size: %d \n', t,NumNex);
    Pos =Pos_all';
    Nex =randNegAll';
    x = [Pos;Nex];
    y = [ones(size(Pos,1),1); -1*ones(size(Nex,1),1)];
    notnanInd=~isnan(sum(x,2));
    x=x(notnanInd,:);
    y=y(notnanInd,:);

    tic;
    [sol,b,sv,obj] = primal_svm(1,x,y,1);
    w = sol;
    bias = b;
    SVs = x(sv,:);
    pSV = SVs(SVs*sol>-b,:);
    nSV = SVs(SVs*sol<-b,:);

    svm =struct('w', reshape(w,size_pos),'bias',bias);
    Model.svm =svm;
    Model.size_pos =size(pos);

    
    t= toc; 
    fprintf('SVM first training ends, takes %f\n',t);
    
    fprintf('Hard negative mining on %d files\n ',opt.numOfNegimage);   
    size_pos =Model.size_pos;
    
    for iter=1:opt.maxiter,
        hardnegstart =tic;
        NegAll =[];
        for imageNumid=1:opt.numOfNegimage
            if size(NegAll,2)<opt.NumOfNexLimit
                tic;
                imageNum =imageNumid;

                % CODE REPLACED FOR EXTRA CREDIT
                %imageRgb = imread(sprintf('./data/image%02d.jpg',imageNum));
                imageRgb = imread(sprintf('./data2/image%02d.jpg',imageNum));

                postive_bb =groundTruthBbs([groundTruthBbs.imageNum]==imageNum);
                featureNeg = feature_pyramid(imageRgb);
                bbw_2d = testfeaturePym(imageRgb,Model);
                if ~isempty(postive_bb)
                    os=bb2dOverlap(bbw_2d,postive_bb.gtBb2D);
                    maxos =max(os,[],2);
                    idxfar = maxos<0.5; 
                    bbw_2d = bbw_2d(idxfar,:);
                end
                %figure,draw_2d(imageRgb,bbw_2d,zeros(size(bbw_2d,1),1),postive_bb);
                
                hard_neg_id = bbw_2d(:,5) > opt.conf_threshold;
                bbw_2d = bbw_2d(hard_neg_id,:);
                [Nex,~,~] = hogGetfeature( bbw_2d, featureNeg,size_pos);
                NegAll = [NegAll,Nex];
                
                t=toc;
                fprintf('New hard neigative: %d Totol: %d threshold: %.3f Time used : %f imageNumid : %d \n',...
                        size(Nex,2),size(NegAll,2),opt.conf_threshold,t,imageNumid);                        
            else
                fprintf('NegAll exceed max number !\n')
                break;
            end
        end
         thardneg=toc(hardnegstart);
         fprintf('Time to collect hard negs :%f\n',thardneg);
         numNewNex = size(NegAll,2);
        
        %% converge or retrain
        if isempty(NegAll)&&imageNumid==opt.numOfNegimage,
            if iter>1,
                fprintf('NegAll are empty !\n');
                break;
            else
                continue;
            end
        else
           % retain SVM
            fprintf('SVM %d retaining start !\n NegAll size: %d \n', iter, size(NegAll,2));
            
            Nex =[NegAll';nSV];
            Pos =[Pos_all'];
            x = [Pos;Nex];
            y = [ones(size(Pos,1),1); -1*ones(size(Nex,1),1)];
            notnanInd=~isnan(sum(x,2));
            x=x(notnanInd,:);
            y=y(notnanInd,:);
            [sol,b,sv,obj] = primal_svm(1,x,y,0.01);
            w = sol;
            bias = b;
            SVs = x(sv,:);
            pSV = SVs(SVs*sol>-b,:);
            nSV = SVs(SVs*sol<-b,:);
            
            svm =struct('w', reshape(w,size_pos),'bias',bias);
            Model.hardnegthr =opt.conf_threshold;
            Model.svm =svm;
            if numNewNex<2&&imageNumid==opt.numOfNegimage,
                break;
            end
            fprintf('SVM iter %d hard negative mining end !\n', iter);

        end
    end


save(Modeltosavefullpath,'Model','-v6');

end
end
