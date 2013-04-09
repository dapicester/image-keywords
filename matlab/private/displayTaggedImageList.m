function displayTaggedImageList(handler, names, tags, varargin)
% DISPLAYTAGGEDIMAGELIST  Display a (subset of the) tagged list of images.
%
%   DISPLAYTAGGEDIMAGELIST(HANDLER, NAMES, SCORES) displays images from
%   the list of image names NAMES and the associated TAGS.
%
%   The function accepts the following options:
%
%   NumImages:: [36]
%     Number of images to display.
%
%   Title::
%     Figure title.

% Author: Paolo D'Apice

opts.numImages = 36; % 6 x 6
opts.title = '';
opts = vl_argparse(opts, varargin);

persistent TITLE
TITLE = 'Tagged images (subset)';

% subset
images = vl_colsubset(names, opts.numImages, 'uniform');
numImages = numel(images);

% display images
figure(handler), clf;
set(handler, 'name', tif(isempty(opts.title), TITLE, ...
                         sprintf('%s: %s', TITLE, opts.title)));
for i = 1:numImages
    vl_tightsubplot(numImages, i, 'box', 'inner');
    imagesc(imread(images{i}));
    
    text(10, 10, tags(:,i), ...
        'background', 'w', 'verticalalignment', 'top', 'fontsize', 8);
    set(gca, 'xtick', [], 'ytick', []), axis image
end
colormap gray


function text = merge(tags)
numTags = numel(tags);
for i = 1:numTags
    text = cellfun(@tmp, text, tags{i}, 'UniformOutput', false);
end



