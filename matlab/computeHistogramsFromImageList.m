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

useCache = length(varargin) > 1;
if useCache
    cache = varargin{1};
else
    cache = [];
end

len = numel(names);
histograms = cell(1, len);
parfor i = 1:len
    if exist(names{i}, 'file')
        fullPath = names{i};
    else
        fullPath = fullfile('../data','person', names{i});
    end
    if useCache
        % try to retrieve from cache
        histograms{i} = getFromCache(fullPath);
        if ~isempty(histograms{i})
            continue
        end
    end
    fprintf('Extracting histogram from %s (%d/%d)\n', fullPath, i, len);
    histograms{i} = computeHistogramFromImage(vocabulary, fullPath);
    if useCache
        % save to cache
        storeToCache(fullPath, cache, histograms{i});
    end
end
histograms = [histograms{:}];

function histogram = getFromCache(fullPath, cache)
[~, name] = fileparts(fullPath);
cachePath = fullfile(cache, [name '.mat']);
if exist(cachePath, 'file')
    data = load(cachePath);
    histogram = data.histogram;
else
    histogram = [];
end

function storeToCache(fullPath, cache, histogram)
[~, name] = fileparts(fullPath);
cachePath = fullfile(cache, [name '.mat']);
vl_xmkdir(cache);
data.histogram = histogram; %#ok<STRNU>
save(cachePath, '-struct', 'data');