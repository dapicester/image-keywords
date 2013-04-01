function dataset = loadDatasets(classname, dir, N)
% LOADDATASET  Load N datasets for target class.

% Author: Paolo D'Apice

% reset random because we want datasets a and b to use the same images
rng(0);
for i = 1:N
    [train(i), val(i)] = loadData(classname, 'datadir', dir);
end
dataset = struct('train', train, 'val', val);
