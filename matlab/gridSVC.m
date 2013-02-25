function params = gridSVC(labels, data)
% GRIDSVC  Grid search for SVC parameter selection.
%   PARAMS = GRIDSVC(LABELS, DATA) Perform cross validation on training
%   data. Use GRIDSVC(..., 'log2c', VALUES) or GRIDSVC(..., 'log2g', VALUES) 
%   to specify values of log2(C) for C-SVC and log2(gamma) for the RBF 
%   kernel function.
% 
%   PARAMS is a data structure containing the fields 'bestc', 'bestg' and
%   'bestcv' containing the best C, gamma and cross-validation values.

% Author: Paolo D'Apice

opts.log2c = -1:-3;
opts.log2g = -10:2:5;
opts = vl_argparse(opts, varargin);

% initialize to default values
params.bestcv = svmtrain(labels, data, '-v 5');
params.bestc = NaN;
params.bestg = NaN;

for log2c = opts.log2c
    for log2g = opts.log2g
        options = ['-v 5 -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
        cv = svmtrain(labels, data, options);
        if (cv >= params.bestcv)
            params.bestcv = cv;
            params.bestc = 2^log2c;
            params.bestg = 2^log2g;
        end
        fprintf('-> %g %g %g (best c=%g, g=%g, rate=%g)\n', ...
                log2c, log2g, cv, params.bestc, params.bestg, params.bestcv);
    end
end