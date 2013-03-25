function [train, val] = loadData(class, varargin)
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
%   Descriptors::
%     Use 'phow', 'phog' or 'both'. Defaults to use both descriptors.
%
%   DataDir:: [DATA_DIR]
%     The directory containing the saved data. Default is defined by global
%     variable but it cannot be accessed in parfors so it must be
%     explicitely specified.

% Author: Paolo D'Apice

global DATA_DIR

opts.ratio = 0.75;
opts.outliers = 1;
opts.dataDir = DATA_DIR;
opts.descriptors = 'both';
opts = vl_argparse(opts, varargin);

% load data
data = load(fullfile(opts.dataDir, [class '_hist.mat']));
reject = load(fullfile(opts.dataDir, [class '_reject_hist.mat']));

len = size(data.histograms, 2);
numTargets = floor(len * opts.ratio);
numOutliers = floor((len - numTargets) * opts.outliers);

indTargets = subset(data.histograms, numTargets);
indOutliers = subset(reject.histograms, numOutliers);

% training data (targets)
train.class = class;
train.names = data.names(indTargets);
train.histograms = double(descriptors(data.histograms(indTargets), opts.descriptors));
train.labels = ones(numTargets, 1);
fprintf('Number of training images: %d targets\n', size(train.histograms, 1));

% validation data (targets and outliers)
val.class = class;
val.names = [data.names(~indTargets); reject.names(indOutliers)];
val.histograms = double([descriptors(data.histograms(~indTargets), opts.descriptors); ...
                         descriptors(reject.histograms(indOutliers), opts.descriptors)]);
val.labels = [ones(len-numTargets, 1); -ones(numOutliers, 1)];
fprintf('Number of validation images: %d targets, %d outliers\n', ...
        sum(val.labels > 0), sum(val.labels < 0));


function ind = subset(data, len)
% SUBSET  Return a subset of LEN rows of the input DATA.
n = size(data, 2);
ind = zeros(1, n);
ind(sort(randperm(n, len))) = 1;
ind = logical(ind);


function out = descriptors(data, sel)
% DESCRIPTORS  Choose the descriptors.
values = struct2cell(data);
phow = values(1,:,:);
phog = values(2,:,:);
switch sel
    case 'phow'
        out = cat(1, phow{:});
    case 'phog'
        out = cat(1, phog{:});
    otherwise
        out = [cat(1, phow{:}), cat(1, phog{:})];
end

