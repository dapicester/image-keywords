function params = gridOneSVM(labels, data, kernel, varargin)
% GRIDONESVM  Grid search for one-class SVM parameter selection.
%
%   PARAMS = GRIDONESVM(LABELS, DATA, KERNEL)  Perform a grid search 
%   on the parameters space using the given DATA and KERNEL. 
%   The objective function is: min sqrt( (n-fsv)^2 + (n-fout)^2 )
%   where fsv and fout are respectively the fraction of support vectors
%   and the fraction of outliers.
%   PARAMS is a data structure containing the fields 'bestn' and
%   'bestobj' containing respectively the best nu and objective function
%   values.
%
%   The function accepts the following options:
%
%   Nu:: [[ 0.01 0.03 0.05 0.1 0.15 0.2 0.3 0.5 0.8 ]]
%     Values of the nu parameter.
%
%   VFolds:: [1]
%     Number of folds on which run the grid search (disabled if 1). 

% Author: Paolo D'Apice

opts.nu = [ 0.01, 0.03, 0.05, 0.1, 0.15, 0.2, 0.3, 0.5, 0.8 ];
opts.vfolds = 5;
opts = vl_argparse(opts, varargin);

numVectors = size(data, 1);
params.bestobj = Inf;

% k-fold partition
folds = cvpartition(labels, 'k', opts.vfolds);

for v = 1:folds.NumTestSets
    fprintf(' ==> fold %d\n',v);
    trainIdx = folds.training(v);
    testIdx = folds.test(v);
    
    % precompute kernel
    [trainData, testData] = svm.precomputeKernel(kernel, ...
                                                 data(trainIdx, :), ...
                                                 data(testIdx, :));

    for n = opts.nu    
        % train model
        options = sprintf('-q -n %g', n);
        model = svm.trainOneSVM(labels(trainIdx), trainData, options);

        % compute objective function
        predicted = svm.predict(labels(testIdx), testData, model, '-q');
        fsv = model.totalSV / numVectors;
        fout = numel(find(predicted == -1)) / numVectors;
        obj = objective(n, fsv, fout);
        
        % evaluate
        if (obj < params.bestobj)
            params.bestobj = obj;
            params.bestn = n;
            fprintf('*')
        else
            fprintf('.')
        end
        fprintf(' %.2f  %.6f\t(best n=%.2f  obj=%.6f)\n', ...
                n, obj, params.bestn, params.bestobj);
    end
end


function o = objective(n, fsv, fout)
% OBJECTIVE  Compute the objective function.
o = sqrt( (n-fsv)^2 + (n-fout)^2 );