% MODELESTIMATION  Model estimation for one-class SVM.

clc, clear all

setup
loadData

if scaling
    [histograms, ranges] = svmScale(histograms);
    testHistograms = svmScale(testHistograms, 'ranges', ranges);
end

%% Grid search on coarse grid

params_coarse = gridOneSVM(labels, histograms);
fprintf('Coarse grid:'), params_coarse                          %#ok<NOPTS>

%% Grid search on finer grid around previous best parameters

neighbors = @(c,w,d) c - w*d : d : c + w*d;

n = neighbors(params.bestn, 3, 0.01);
log2g = neighbors(log2(params.bestg), 3, 0.25);

params_fine = gridOneSVM(labels, histograms, 'n', n, 'log2g', log2g);
fprintf('Fine grid:'), params_fine                              %#ok<NOPTS>

%% Test

model = svmtrain(labels, histograms, ['-s 2 -n ' num2str(params_fine.bestn) ' -g ' num2str(params_fine.bestg)]);

% on training data
svmpredict(labels, histograms, model);

% on validation data
[p a s] = svmpredict(testLabels, testHistograms, model);
