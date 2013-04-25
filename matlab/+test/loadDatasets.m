function dataset = loadDatasets(classes, class, dir, N, varargin)
% LOADDATASETS  Load N datasets for target class.

% Author: Paolo D'Apice

opts.verbose = false;
opts.classifier = 'single';
opts = vl_argparse(opts, varargin);

printf = printHandle(opts.verbose);

switch opts.classifier
    case 'multi'
        flag = true;
    case 'single'
        flag = false;
end

% reset random because we want datasets to use the same images
rng(0);

for i = 1:N
    printf('Loading datesets for class "%s" (%d/%d)\n', class, i, N)
    [train(i), val(i)] = loadData(classes, class, ...
                                  'trainOutliers', flag, ...
                                  'datadir', dir);
end
dataset = struct('train', train, 'val', val);
