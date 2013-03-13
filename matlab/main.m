% MAIN  Train and test a classifier.

% Author: Paolo D'Apice

clear all
setup

for class = { 'animal', 'cellphone', 'face', 'person' }
    classname = char(class);
    
    % load data
    fprintf(' * Loading data for class "%s"\n', classname);
    [train,test] = loadData(classname);

    % scaling data (optional)
    if SCALING
        fprintf('Scaling data\n')
        [train.histograms, ranges] = svmScale(train.histograms);
        test.histograms = svmScale(test.histograms, 'ranges', ranges);
    end

    % repeat N times and get average results
    N = 10;
    results = cell(N,1);
    for i = 1:N
        fprintf(' * Classifying images in class "%s" (%d/%d)\n', classname, i, N)
        results{i} = classify(train, test, @chi2expKernel);
    end
    results = struct2dataset(cell2mat(results));
    
    fprintf('----------------------------\n');
    fprintf(' Class %s\n', classname);
    fprintf('----------------------------\n');
    fprintf('  Average accuracy : %f\n', mean(results.accuracy))
    fprintf('  Average precision: %f\n', mean(results.precision))
    fprintf('  Average recall   : %f\n', mean(results.recall))
    fprintf('  Average f-score  : %f\n', mean(results.fscore))
    fprintf('----------------------------\n');
    
    disp('Press a key to continue with next class, CTRL-C to quit'), pause
end
