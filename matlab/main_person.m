% MAIN_PERSON Train and test a classifier on "person" images.

clc, clear all
setup;

%% Data preparation

loadData

%% Train a classifier

% TODO: scaling data (optional)
% TODO: model estimation

model = trainOneSVM(labels, histograms);

% evaluate on training data
[predictedLabels, accuracy, scores] = predictSVM(labels, histograms, model);
fprintf('Training accuracy: %.4f%% (%d/%d)\n', ...
        accuracy(1), numel(find(predictedLabels == labels)), length(labels)); 

% visualize the ranked list of images
% figure(1), clf, set(1, 'name', 'Ranked training images (subset)');
% displayRankedImageList('person', names, scores(1:length(names)));

% Visualize the precision-recall curve
% figure(2), clf, set(2, 'name', 'Precision-recall on train data');
% vl_pr(labels, scores);

%% Classify test images and assess performance

[predictedLabels, accuracy, scores] = predictSVM(testLabels, testHistograms, model);
fprintf('Testing accuracy: %.4f%% (%d/%d)\n', ...
        accuracy(1), numel(find(predictedLabels == testLabels)), length(testLabels)); 

% visualize the ranked list of images
figure(3), clf, set(3, 'name', 'Ranked testing images (subset)');
displayRankedImageList('person', names, scores(1:length(testNames)));

% Visualize the precision-recall curve
figure(4), clf, set(4, 'name', 'Precision-recall on test data');
vl_pr(testLabels, scores);

% results
[~, ~, info] = vl_pr(testLabels, scores);
fprintf('Test AP: %.2f\n', info.auc);                                                                                                                                                                           
 
[~, perm] = sort(scores, 'descend');
topK = 36;
fprintf('Correctly retrieved in the top %d: %d\n', topK, sum(testLabels(perm(1:topK)) > 0));
