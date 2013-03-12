clc, clear all
setup

for class = { 'animal', 'cellphone', 'face', 'person' }
    disp(class)
    [train, test] = loadData(char(class));

    %[train.histograms, ranges] = svmScale(train.histograms);
    %test.histograms = svmScale(test.histograms, 'ranges', ranges);    

    for k = { @linearKernel, ...
              @rbfKernel, ...
              @chi2Kernel, ...
              @chi2expKernel, ...
              @histintKernel }
        kernel = k{1};
        disp(func2str(kernel));
        [train2, test2] = precomputeKernel(kernel, train.histograms, test.histograms);
        model = trainOneSVM(train.labels, train2);
        pred = predictSVM(test.labels, test2, model);
        stats(pred, test.labels, 'plot', true, 'print', true); 
        disp('Press a key to continue with next kernel'), pause
    end
    disp('Press a key to continue with next class'), pause
end