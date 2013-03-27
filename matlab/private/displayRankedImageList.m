function displayRankedImageList(names, scores, varargin)
% DISPLAYRANKEDIMAGELIST  Display a (subset of a) ranked list of images.
%   DISPLAYRANKEDIMAGELIST(NAMES, SCORES) displays 36 images from
%   the list of image names NAMES sorted by decreasing scores
%   SCORES.
%
%   Use DISPLAYRANKEDIMAGELIST(..., 'numImages', N) to display N images.

% Author: Andrea Vedaldi
% Author: Paolo D'Apice

opts.numImages = 6*6;
opts = vl_argparse(opts, varargin);

% change NaNs
bad = isnan(scores);
scores(bad) = min(scores) - eps;

% sort and subset
[~, perm] = sort(scores, 'descend');
perm = vl_colsubset(perm', opts.numImages, 'uniform');

% display images
for i = 1 : length(perm)
    vl_tightsubplot(length(perm), i, 'box', 'inner');
    
    fullPath = names{perm(i)};
    imagesc(imread(fullPath));
    
    text(10, 10, sprintf('score: %.4f', scores(perm(i))), ...
        'background','w', 'verticalalignment','top', 'fontsize', 8) ;
    set(gca, 'xtick', [], 'ytick', []), axis image
end
colormap gray
