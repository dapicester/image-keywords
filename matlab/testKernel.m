% TESTKERNEL  Run classification using different kernels.

% Autor: Paolo D'Apice

clc, clear all
setup

for class = { 'animal', 'cellphone', 'face', 'person' }
    classname = char(class);
    
    fprintf('* Class "%s"\n', classname);
    [train, test] = loadData(classname);

    if SCALING
        [train.histograms, ranges] = svmScale(train.histograms);
        test.histograms = svmScale(test.histograms, 'ranges', ranges);
    end
        
    for k = { @linearKernel, ...
              @rbfKernel, ...
              @chi2Kernel, ...
              @chi2expKernel, ...
              @hellingerKernel, ...
              @histintKernel }
        kernel = k{1};
        fprintf(' - %s:\n', func2str(kernel));
        [train2, test2] = precomputeKernel(kernel, train.histograms, test.histograms);
        model = trainOneSVM(train.labels, train2, '-q');
        pred = predictSVM(test.labels, test2, model, '-q');
        stats(pred, test.labels, 'plot', true, 'print', true); 
        disp('Press a key to continue with next kernel'), pause
    end
    disp('Press a key to continue with next class'), pause
end