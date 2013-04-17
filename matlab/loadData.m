function [train, val] = loadData(classes, class, varargin)
% LOADDATA  Load training and validation data.
%
%   [TRAIN, VAL] = LOADDATA(CLASS) Load training and validation data 
%   for the given CLASS.
%
%   The function accepts the following options:
%
%   Ratio:: [0.75]
%     Define the ratio of training data. By default 75% of data is put in
%     the train data set and the remainder 25% is used for validation.
%
%   Outliers:: [1]
%     Define the ratio between outliers and targets in the validation 
%     data set. By default the number of outliers is equal to the number
%     of targets.
%
%   MaxNumber:: [500]
%     Define the maximum number of sample images to be used for training.
%
%   Descriptors::
%     Use 'phow', 'phog' or 'both'. Defaults to use both descriptors
%     if available.
%
%   DataDir:: [DATA_DIR]
%     The directory containing the saved data. Default is defined by global
%     variable but it cannot be accessed in parfors so it must be
%     explicitely specified.

% Author: Paolo D'Apice

global DATA_DIR

% TODO opts.sets = 'one'|'multi' => loadDataOneClass|loadDataMultiClass

opts.ratio = 0.75;
opts.outliers = 1;
opts.maxNumber = 500;
opts.dataDir = DATA_DIR;
opts.descriptors = 'both';
opts = vl_argparse(opts, varargin);

% load target data
target = loadFile(fullfile(opts.dataDir, [class '_hist.mat']));

% load outliers data
outliers.histograms = [];
outliers.names = {};
for c = setdiff(classes, class)
    r = loadFile(fullfile(opts.dataDir, [char(c) '_hist.mat']));
    outliers.histograms = [outliers.histograms r.histograms];
    outliers.names = cat(1, outliers.names, r.names);
end

% get at most maxNumber of target samples
len = size(target.histograms, 2);
numTargets = min(floor(len * opts.ratio), opts.maxNumber);
numOutliers = min(floor((len - numTargets) * opts.outliers), ...
                  size(outliers.histograms, 2));

% get subset indices
indTargets = subset(target.histograms, numTargets);
indOutliers = subset(outliers.histograms, numOutliers);

% training data (targets only)
train.names = target.names(indTargets);
train.histograms = double(getDescriptors(target.histograms(indTargets), opts.descriptors));
train.labels = ones(numTargets, 1);
fprintf('Number of training images: %d targets\n', size(train.histograms, 1));

% validation data (targets and outliers)
val.names = [target.names(~indTargets); outliers.names(indOutliers)];
val.histograms = double([getDescriptors(target.histograms(~indTargets), opts.descriptors); ...
                         getDescriptors(outliers.histograms(indOutliers), opts.descriptors) ]);
val.labels = [ones(len-numTargets, 1); -ones(numOutliers, 1)];
fprintf('Number of validation images: %d targets, %d outliers\n', ...
        sum(val.labels > 0), sum(val.labels < 0));


function ind = subset(data, len)
% SUBSET  Return logical indices of a subset of LEN rows of the input DATA.
numData = size(data, 2);
len = min(numData, len);
perm = randperm(numData);
ind = false(1, numData);
ind(sort(perm(1:len))) = true;
