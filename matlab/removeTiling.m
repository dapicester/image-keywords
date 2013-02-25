function untiled = removeTiling(histograms, varargin)
% REMOVETILING  Convert spatial to simple histogram.
%   HISTOGRAM = REMOVETILING(HISTOGRAM) removes the
%   spatial information from the RxC spatial histogram HISTOGRAM.
%   Use REMOVETILING(..., 'tiles',[R C]) to override the default 
%   2x2 tile grid.

% Author: Paolo D'Apice

opts.tiles = [2 2];
opts = vl_argparse(opts, varargin);

n = opts.tiles(1) * opts.tiles(2);
[numWords, len] = size(histograms);

untiled = zeros(numWords, len / n);
for i = 1:n
    untiled = untiled + histograms(:, i:n:end);
end

%untiled = untiled / n ;
