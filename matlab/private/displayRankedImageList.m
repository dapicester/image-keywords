function displayRankedImageList(handler, names, scores, varargin)
% DISPLAYRANKEDIMAGELIST  Display a (subset of the) ranked list of images.
%
%   DISPLAYRANKEDIMAGELIST(HANDLER, NAMES, SCORES) displays images from
%   the list of image names NAMES sorted by decreasing SCORES.
%
%   The function accepts the following options:
%
%   NumImages:: [36]
%     Number of images to display.
%
%   Title::
%     Figure title.

% Author: Andrea Vedaldi
% Author: Paolo D'Apice

opts.numImages = 36; % 6 x 6
opts.title = '';
opts = vl_argparse(opts, varargin);

persistent TITLE
TITLE = 'Ranked images (subset)';

% change NaNs
bad = isnan(scores);
scores(bad) = min(scores) - eps;

% sort and subset
[~, perm] = sort(scores, 'descend');
perm = vl_colsubset(perm', opts.numImages, 'uniform');
numPerm = numel(perm);

% display images
figure(handler), clf;
set(handler, 'name', tif(isempty(opts.title), TITLE, ...
                         sprintf('%s: %s', TITLE, opts.title)));
for i = 1:numPerm
    vl_tightsubplot(numPerm, i, 'box', 'inner');
    imagesc(imread(names{perm(i)}));
    score = scores(perm(i));
    text(10, 10, sprintf('score: %.4f', score), ...
        'color', tif(score>0, [.17 .51 .34], [.85 .16 0]), ...
        'background', 'w', 'verticalalignment', 'top', 'fontsize', 8);
    set(gca, 'xtick', [], 'ytick', []), axis image
end
colormap gray
