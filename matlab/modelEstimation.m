function params = modelEstimation(class)
% MODELESTIMATION  Model estimation for one-class SVM.
%   PARAMS = MODELESTIMATION(CLASS) Perform grid search on one-class SVM
%   parameters for the given class.

% Author: Paolo D'Apice

global SCALING

fprintf('Model estimantion for class "%s"\n\n', class)

[~, train, test] = loadData(class);

if SCALING
    fprintf('Scaling data\n')
    [train.histograms, ranges] = svmScale(train.histograms);
    test.histograms = svmScale(test.histograms, 'ranges', ranges);
end

%% Grid search on coarse grid

params = gridOneSVM(train.labels, train.histograms, 'n', 0.5);
fprintf('Coarse grid:'), params                                 %#ok<NOPTS>

%% Grid search on finer grid around previous best parameters

neighbors = @(c,w,d) c - w*d : d : c + w*d;

n = neighbors(params.bestn, 3, 0.02);
log2g = neighbors(log2(params.bestg), 3, 0.5);

fprintf('Fine grid params:'), n, log2g                          %#ok<NOPTS>
fprintf('Press a key to continue'), pause
params_fine = gridOneSVM(train.labels, train.histograms, 'n', n, 'log2g', log2g);
fprintf('Fine grid:'), params_fine                              %#ok<NOPTS>

%% Test

model = svmtrain(train.labels, train.histograms, ['-s 2 -n ' num2str(params_fine.bestn) ' -g ' num2str(params_fine.bestg)]);

% on training data
svmpredict(train.labels, train.histograms, model);

% on validation data
predictedLabels = svmpredict(test.labels, test.histograms, model);
stats(predictedLabels, test.labels, 'plot', true);
