% MAIN_PERSON Train and test a classifier on "person" images.

clc, clear all
setup;

%% Data preparation

loadData

%% Train a classifier

% scaling data (optional)
if scaling
    [histograms, ranges] = svmScale(histograms);
end

model = trainOneSVM(labels, histograms);

% evaluate on training data
[predictedLabels, ~, scores] = predictSVM(labels, histograms, model);

% visualize the ranked list of images
% figure(1), clf, set(1, 'name', 'Ranked training images (subset)');
% displayRankedImageList('person', names, scores(1:length(names)));

% Visualize the precision-recall curve
% figure(2), clf, set(2, 'name', 'Precision-recall on train data');
% vl_pr(labels, scores);

% results
[~, ~, info] = vl_pr(labels, scores);
fprintf('Train AP: %.2f\n', info.auc);

fprintf(' === Training results ===\n');
stats(predictedLabels, labels);

%% Classify test images and assess performance

if scaling
    testHistograms = svmScale(testHistograms, 'ranges', ranges);
end
[predictedLabels, ~, scores] = predictSVM(testLabels, testHistograms, model);

% visualize the ranked list of images
figure(3), clf, set(3, 'name', 'Ranked testing images (subset)');
displayRankedImageList('person', names, scores(1:length(testNames)));

% Visualize the precision-recall curve
figure(4), clf, set(4, 'name', 'Precision-recall on test data');
vl_pr(testLabels, scores);

% results
[~, ~, info] = vl_pr(testLabels, scores);
fprintf('Test AP: %.2f\n', info.auc);                                                                                                                                                                           

fprintf('Testing results:\n');
stats(predictedLabels, testLabels);

[~, perm] = sort(scores, 'descend');
topK = 36;
fprintf('\nCorrectly retrieved in the top %d: %d\n', topK, sum(testLabels(perm(1:topK)) > 0));
