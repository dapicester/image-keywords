function histograms = computeHistogramsFromImageList(vocabulary, names, varargin)
% COMPUTEHISTOGRAMSFROMIMAGELIST  Compute historams for multiple images.
%   HISTOGRAMS = COMPUTEHISTOGRAMSFROMIMAGELIST(VOCABULARY, NAMES)
%   computes the histograms of visual words for the list of image
%   paths NAMES by applying iteratively COMPUTEHISTOGRAMFROMIMAGE().
%
%   COMPUTEHISTOGRAMSFROMIMAGELIST(VOCABULARY, NAMES, CACHE) caches
%   the results to the CACHE directory.

% Author: Andrea Vedaldi
% Author: Paolo D'Apice

conf.descriptors = 0;
[conf, varargin] = vl_argparse(conf, varargin);

switch conf.descriptors
    case 'phog', opts = { 'phow', false };
    case 'phow', opts = { 'phog', false };
    otherwise,   opts = {};
end
opts = [opts, varargin];

len = numel(names);
histograms = cell(1, len);
parfor i = 1:len
    fullPath = names{i};
    fprintf('  Extracting histograms from %s (%d/%d)\n', fullPath, i, len);
    histograms{i} = computeHistogramFromImage(vocabulary, fullPath, opts{:}); %#ok<PFBNS>
end
histograms = [histograms{:}];
