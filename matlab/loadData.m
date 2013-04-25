function [train, val] = loadData(classes, class, varargin)
% LOADDATA  Load training and validation data for the one-class problem.
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
%   TrainOutliers:: [false]
%     Include outliers in the training data.
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
%
%   Verbose:: [false]
%     Print verbose messages.

% Author: Paolo D'Apice

global DATA_DIR

opts.verbose = false;
opts.ratio = 0.75;
opts.outliers = 1;
opts.trainOutliers = false;
opts.maxNumber = 500;
opts.dataDir = DATA_DIR;
opts.descriptors = 'both';
opts = vl_argparse(opts, varargin);

printf = printHandle(opts.verbose);

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

lenTargets = size(target.histograms, 2);
lenOutliers = size(outliers.histograms, 2);
printf('Available samples: %d targets, %d outliers\n', lenTargets, lenOutliers);

% get at most maxNumber of target samples
[numTargets, numOutliers] = getNumSamples();

% get subset indices
indTargets = subset(target.histograms, numTargets);
indOutliers = subset(outliers.histograms, numOutliers);

% data sets
train = getTrainData();
val = getValidationData();

    
function [nt, no] = getNumSamples()
    if opts.trainOutliers
        nt = numSamples(lenTargets, opts.ratio, opts.maxNumber);
        no = numSamples(lenOutliers, opts.ratio, opts.maxNumber);
    else
        nt = numSamples(lenTargets, opts.ratio, opts.maxNumber);
        no = numSamples(lenTargets - nt, opts.outliers, lenOutliers);
    end
end


function data = getTrainData()
    if opts.trainOutliers
        data.names = [ target.names(indTargets); ...
                       outliers.names(indOutliers) ];
        data.histograms = double( ...
            [ getDescriptors(target.histograms(indTargets), opts.descriptors); ...
              getDescriptors(outliers.histograms(indOutliers), opts.descriptors) ]);
        data.labels = [ ones(numTargets, 1); ...
                       -ones(numOutliers, 1) ];
        printf('Number of training images: %d targets, %d outliers\n', ...
               numTargets, numOutliers);
    else
        data.names = target.names(indTargets);
        data.histograms = double(getDescriptors(target.histograms(indTargets), opts.descriptors));
        data.labels = ones(numTargets, 1);
        printf('Number of training images: %d targets\n', ...
               size(data.histograms, 1));
    end
end


function data = getValidationData()
    if opts.trainOutliers
        data.names = [target.names(~indTargets); outliers.names(~indOutliers)];
        data.histograms = double([getDescriptors(target.histograms(~indTargets), opts.descriptors); ...
                                 getDescriptors(outliers.histograms(~indOutliers), opts.descriptors)]);
        data.labels = [ones(lenTargets-numTargets, 1); -ones(lenOutliers-numOutliers, 1)];
        printf('Number of validation images: %d targets, %d outliers\n', ...
               sum(data.labels > 0), sum(data.labels < 0));
    else
        data.names = [target.names(~indTargets); outliers.names(indOutliers)];
        data.histograms = double([getDescriptors(target.histograms(~indTargets), opts.descriptors); ...
                                 getDescriptors(outliers.histograms(indOutliers), opts.descriptors) ]);
        data.labels = [ones(lenTargets-numTargets, 1); -ones(numOutliers, 1)];
        printf('Number of validation images: %d targets, %d outliers\n', ...
               sum(data.labels > 0), sum(data.labels < 0));
    end
end

end