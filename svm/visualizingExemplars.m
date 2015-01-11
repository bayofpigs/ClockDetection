addpath(genpath('.'));

%% Visualize model 1
figure
load('TrainedModel01.mat');
subplot(1, 3, 1);
imshow(Model.posRgb);

subplot(1, 3, 2);
showHOG(Model.posfeature);

subplot(1, 3, 3);
showHOG(Model.svm.w);

%% Visualize model 2
figure
load('TrainedModel02.mat');
subplot(1, 3, 1);
imshow(Model.posRgb);

subplot(1, 3, 2);
showHOG(Model.posfeature);

subplot(1, 3, 3);
showHOG(Model.svm.w);

%% Visualize model 3
figure
load('TrainedModel03.mat');
subplot(1, 3, 1);
imshow(Model.posRgb);

subplot(1, 3, 2);
showHOG(Model.posfeature);

subplot(1, 3, 3);
showHOG(Model.svm.w);
