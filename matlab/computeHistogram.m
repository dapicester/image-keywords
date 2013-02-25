function histogram = computeHistogram(width, height, keypoints, words, varargin)
% COMPUTEHISTOGRAM  Compute a spatial histogram of visual words.
%   HISTOGRAM = COMPUTEHISTOGRAM(WIDTH, HEIGHT, KEYPOINTS, WORDS)
%   computes a RxC spatial histogram of the N visual words WORDS.
%   KEYPOINTS is a 2 x N matrix of x,y coordinates of the
%   visual words and WIDTH and HEIGHT are the image dimensions; these
%   quantities are needed for the geometric tiling.
%   By default the spatial histogram is computed on a 2x2 tile
%   grid using 1000 words. Use COMPUTEHISTOGRAM(..., 'numWords', NUM) or
%   COMPUTEHISTOGRAMS(..., 'tiles', [ROWS COLUMNS]) to override default
%   values.

% Author: Andrea Vedaldi
% Author: Paolo D'Apice

opts.numWords = 1000;
opts.tiles = [2 2];
opts = vl_argparse(opts, varargin);

binsx = vl_binsearch(linspace(1, width, opts.tiles(1) + 1), keypoints(1,:));
binsy = vl_binsearch(linspace(1, height, opts.tiles(2) + 1), keypoints(2,:));
bins = sub2ind([opts.tiles(2) opts.tiles(1) opts.numWords], ...
               binsy, binsx, words);
htile = zeros(opts.tiles(2) * opts.tiles(1) * opts.numWords, 1);
htile = vl_binsum(htile, ones(size(bins)), bins);

histogram = single(htile / sum(htile));
