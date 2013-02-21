function params = gridOneSVM(labels, data, varargin)
% GRIDONESVM  Grid search for one-class SVM parameter selection.
%   PARAMS = GRIDONESVM(LABELS, DATA) Perform cross validation on training
%   data. Use GRIDONESVM(..., 'n', VALUES) or GRIDONESVM(..., 'log2g', VALUES) 
%   to specify values of nu for one-class SVM and log2(gamma) for the RBF
%   kernel function.
% 
%   PARAMS is a data structure containing the fields 'bestn', 'bestg' and
%   'bestcv' containing the best nu, gamma and cross-validation values.
%
% Author: Paolo D'Apice

opts.n = 0.1:0.1:0.8;
opts.log2g = -15:2:5;
opts = vl_argparse(opts, varargin);

% initialize to default values
params.bestcv = svmtrain(labels, data, '-s 2 -v 5');
params.bestn = NaN;
params.bestg = NaN;

for n = opts.n
    for log2g = opts.log2g
        options = ['-s 2 -v 5 -n ', num2str(n), ' -g ', num2str(2^log2g)];
        cv = svmtrain(labels, data, options);
        if (cv >= params.bestcv)
            params.bestcv = cv;
            params.bestn = n;
            params.bestg = 2^log2g;
        end
        fprintf('-> %g %g %g (best n=%g, g=%g, rate=%g)\n', ...
                n, log2g, cv, params.bestn, params.bestg, params.bestcv);
    end
end