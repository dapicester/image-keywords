function results = runClassification(classname, varargin)
% RUNCLASSIFICATION  Repeatedly un the classification algorithm.
%   
%   The function accepts the following options:
%
%   Times:: [10]
%     Number of test executions.
%
%   Descriptors:: ['both']
%     Descriptors to use between 'phow', 'phog', 'both'.
%
%   Kernel:: [@linearKernel]
%     Kernel function for the SVM classifier.
%
%   DataDir:: [global DATA_DIR]
%     The directory containing histogram files.


% Author: Paolo D'Apice

global DATA_DIR SCALING

opts.times = 10;
opts.descriptors = 'both';
opts.kernel = @linearKernel;
opts.dataDir = DATA_DIR;
opts = vl_argparse(opts, varargin);

% repeat N times and get average results
results = cell(opts.times, 1);
parfor i = 1:opts.times
    % load data
    fprintf(' * Loading data for class "%s"\n', classname);
    
    % use explicit dataDir because in parfor
    [train,test] = loadData(classname, 'dataDir', opts.dataDir, ...
                            'descriptors', opts.descriptors);

    % scaling data (optional)
    if SCALING
        fprintf('Scaling data\n')
        [train.histograms, ranges] = svmScale(train.histograms);
        test.histograms = svmScale(test.histograms, 'ranges', ranges);
    end

    % classify
    fprintf(' * Classifying images in class "%s" (%d/%d)\n', classname, i, opts.times)
    results{i} = classify(train, test, opts.kernel);
end
results = struct2dataset(cell2mat(results));
