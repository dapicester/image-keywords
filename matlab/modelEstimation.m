% MODELESTIMATION  Model estimation for one-class SVM.

clear all

setup
loadData

if scaling
    [histograms, ranges] = svmScale(histograms);
    testHistograms = svmScale(testHistograms, 'ranges', ranges);
end

%% Grid search on coarse grid

params = gridOneSVM(labels, histograms);
fprintf('Coarse grid:'), params                                 %#ok<NOPTS>

%% Grid search on finer grid around previous best parameters

neighbors = @(c,w,d) c - w*d : d : c + w*d;

n = neighbors(params.bestn, 3, 0.02);
log2g = neighbors(log2(params.bestg), 3, 0.5);

fprintf('Fine grid params:'), n, log2g, pause;                  %#ok<NOPTS>
params_fine = gridOneSVM(labels, histograms, 'n', n, 'log2g', log2g);
fprintf('Fine grid:'), params_fine                              %#ok<NOPTS>

%% Test

model = svmtrain(labels, histograms, ['-s 2 -n ' num2str(params_fine.bestn) ' -g ' num2str(params_fine.bestg)]);

% on training data
svmpredict(labels, histograms, model);

% on validation data
predictedLabels = svmpredict(testLabels, testHistograms, model);
stats(predictedLabels, testLabels, 'plot', true);
