function params = modelEstimation(class, kernel)
% MODELESTIMATION  Model estimation for one-class SVM.
%   PARAMS = MODELESTIMATION(CLASS) Perform grid search on one-class SVM
%   parameters for the given class.

% Author: Paolo D'Apice

global SCALING

fprintf('Model estimation for class "%s"\n\n', class)

[train, test] = loadData(class, 'descriptors', 'both');

if SCALING
    fprintf('Scaling data\n')
    [train.histograms, ranges] = svmScale(train.histograms);
    test.histograms = svmScale(test.histograms, 'ranges', ranges);
end

%% Grid search on coarse grid

params = gridOneSVM(train.labels, train.histograms, kernel);
disp('Coarse grid parameters:'), disp(params)
disp('Press a key to continue with finer grid'), pause

%% Grid search on finer grid around previous best parameters

while true
    delta = input('Delta? (0.05) ');
    if isempty(delta), delta = 0.05; end
    n = neighbors(params.bestn, 3, delta, 0.01);
    %log2g = neighbors(log2(params.bestg), 3, 0.5);
    disp('New values of n:'), disp(n)
    cont = input('Accept values? (Y/n) ', 's');
    if isempty(cont) || strcmpi(cont, 'y'), break, end
end

params2 = gridOneSVM(train.labels, train.histograms, kernel, 'n', n);
disp('Fine grid parameters:'), disp(params2)

if params2.bestobj < params.bestobj
    disp('Using fine grid parameters:')
    n = params2.bestn %#ok<NOPRT>
else
    disp('Using coarse grid parameters:')
    n = params.bestn %#ok<NOPRT>
end

disp('Press a key to test'), pause

%% Test

[train.khistograms, test.khistograms] = precomputeKernel(kernel, train.histograms, test.histograms);
options = [ '-q -n ', num2str(n) ]; %, ' -g ', num2str(2^log2g)];
model = trainOneSVM(train.labels, train.khistograms, options);
predictedLabels = predictSVM(test.labels, test.khistograms, model, '-q');
stats(predictedLabels, test.labels, 'plot', true, 'print', true);


function out = neighbors(center, width, delta, lower)
% NEIGHBORS  Define neighbor intervals.
out = center - width*delta : delta : center + width*delta;
out = out(out >= lower);
