function displayRankedImageList(class, names, scores, varargin)
% DISPLAYRANKEDIMAGELIST  Display a (subset of a) ranked list of images.
%   DISPLAYRANKEDIMAGELIST('CLASS', NAMES, SCORES) displays 36 images from
%   the list of image names NAMES sorted by decreasing scores
%   SCORES.
%
%   Use DISPLAYRANKEDIMAGELIST(..., 'numImages', N) to display N
%   images. Use DISPLAYRANKEDIMAGELIST(..., 'uniform', true) to select
%   images uniformly in the list, rather than from the top.

% Author: Andrea Vedaldi
% Author: Paolo D'Apice

opts.numImages = 6*6;
opts.uniform = false;
opts.outliers = false;
opts = vl_argparse(opts, varargin);

global DATA_DIR

bad = isnan(scores);
scores(bad) = min(scores) - eps;

if opts.outliers, sorting = 'ascend'; else sorting = 'descend'; end
[~, perm] = sort(scores, sorting);
if opts.uniform
    perm = vl_colsubset(perm', opts.numImages, 'uniform');
else
    perm = vl_colsubset(perm', opts.numImages, 'beginning');
end
for i = 1:length(perm)
    vl_tightsubplot(length(perm), i, 'box', 'inner');
    fullPath = fullfile(DATA_DIR, class, names{perm(i)});
    if ~exist(fullPath, 'file')
        % XXX it is the rejection class
        fullPath = fullfile(DATA_DIR, 'reject', names{perm(i)});
    end
    imagesc(imread(fullPath));
    text(10, 10, sprintf('score: %.4f', scores(perm(i))), ...
        'background','w',...
        'verticalalignment','top', ...
        'fontsize', 8) ;
    set(gca, 'xtick', [], 'ytick', []), axis image
end
colormap gray
