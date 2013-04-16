function dataset = loadDatasets(classes, class, dir, N)
% LOADDATASETS  Load N datasets for target class.

% Author: Paolo D'Apice

% reset random because we want datasets a and b to use the same images
rng(0);
for i = 1:N
    fprintf('Loading datesets for class "%s" (%d/%d)\n', class, i, N)
    [train(i), val(i)] = loadData(classes, class, 'datadir', dir);
end
dataset = struct('train', train, 'val', val);
