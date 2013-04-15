function data = runDemo(dataDir, classes)
% RUNDEMO  Assign labels to the given images.

% Author: Paolo D'Apice

rng(0); % no surprises during demo

data = computeHistograms(dataDir);
truth = readFile(dataDir);

numClasses = numel(classes);
numImages = numel(data.names);
data.tags = cell(numClasses, numImages);

for i = 1:numClasses
    classname = char(classes{i});
    
    fprintf('Training model for class "%s" ...\n', classname);
    [train, val] = loadData(classname);
    
    % TODO parameters
    [train.mapped, val.mapped, data.mapped] = svm.precomputeKernel(...
                                                @kernel.linear, ...
                                                train.histograms, ...
                                                val.histograms, ...
                                                data.histograms);

    % train
    options = '-q';
    model = svm.trainOneSVM(train.labels, train.mapped, options);

    % validate
    [~,~,scores] = svm.predict(val.labels, val.mapped, model, '-q');
    %displayRankedImageList(1, val.names, scores, 'Title', 'Validation data');
    [~,~,info] = vl_pr(val.labels, scores);
    fprintf('Validation AP: %.2f %%\n', info.auc*100);

    % test
    [~,~,scores] = svm.predict(data.labels, data.mapped, model, '-q');
    %displayRankedImageList(2, data.names, scores, 'Title', 'Test data');

    data.tags(i,:) = setLabels(classname, scores);
end
displayTaggedImageList(3, data.names, data.tags, truth);


function data = computeHistograms(dataDir)
% COMPUTEHISTOGRAMS  Extract features from images in DATADIR.

% get file names
data.names = getImageSet(dataDir);
numImages = numel(data.names);
fprintf('Found %d test images\n', numImages);

% compute featurs
% TODO  histogram configuration
histograms = computeHistogramsFromImageList({}, data.names, ...
                                'descriptors', 'phog', 'levels', 1, ...
                                'cache', fullfile(dataDir, 'cache'));
data.histograms = double(getDescriptors(histograms, 'phog'));

% others
data.labels = zeros(numImages, 1); % labels are unknown
data.class = 'demo';


function truth = readFile(dataDir)
% READFILE  Read file names and tags from text file.
fid = fopen(fullfile(dataDir, 'demo.txt'));
values = textscan(fid, '%s %s'); % format: filename tags
fclose(fid);
names = cellfun(@(name) fullfile(dataDir, name), values{1}, ...
                'UniformOutput', false); % add fullpath
tags = cellfun(@(tag) tif(strcmp(tag, 'none'), '', tag), values{2}, ...
                'UniformOutput', false); % remove 'none' tag
truth = containers.Map(names, tags);
