function [train, val] = loadData2(classes, varargin)
% LOADDATA  Load training and validation data for the multi-class problem.
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

opts.ratio = 0.75;
opts.maxNumber = 500;
opts.dataDir = DATA_DIR;
opts.descriptors = 'both';
opts = vl_argparse(opts, varargin);

% load data
numClasses = numel(classes);
data = cell(numClasses, 1);
for i = 1:numClasses
    data{i} = loadFile(fullfile(opts.dataDir, [char(classes{i}) '_hist.mat']));
end

train = struct('names', [], 'histograms', [], 'labels', []);
val = struct('names', [], 'histograms', [], 'labels', []);
for i = 1:numClasses
    class = char(classes{i});
    target = data{i};
    
    % get at most maxNumber of samples
    len = size(target.histograms, 2);
    numTrain = min(floor(len * opts.ratio), opts.maxNumber);

    % get subset indices
    indTrain = subset(target.histograms, numTrain);
    
    % training data
    names = target.names(indTrain);
    histograms = double(getDescriptors(target.histograms(indTrain), opts.descriptors));

    train.names = cat(1, train.names, names);
    train.histograms = cat(1, train.histograms, histograms);
    train.labels = cat(1, train.labels, i * ones(numTrain, 1));
    fprintf('Number of training images: %d %s\n', numTrain, class);

    % validation data (targets and outliers)
    names = target.names(~indTrain);
    histograms = double(getDescriptors(target.histograms(~indTrain), opts.descriptors));

    val.names = cat(1, val.names, names);
    val.histograms = cat(1, val.histograms, histograms);
    val.labels = cat(1, val.labels, i * ones(len-numTrain, 1));
    fprintf('Number of validation images: %d %s\n', len-numTrain, class);
end
