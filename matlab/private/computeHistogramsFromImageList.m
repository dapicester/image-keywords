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

len = numel(names);
histograms = cell(1, len);
parfor i = 1:len
    fullPath = names{i};
    fprintf('  Extracting histograms from %s (%d/%d)\n', fullPath, i, len);
    histograms{i} = computeHistogramFromImage(vocabulary, fullPath);
end
histograms = [histograms{:}];
