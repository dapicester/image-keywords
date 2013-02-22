function [scaled, ranges] = svmScale(input, varargin)
% SVMSCALE Scale data for use with LIBSVM.
% 
%   [SCALED, RANGES] = SVMSCALE(INPUT)  Scale input data to a restricted
%   range. Use SVMSCALE(..., 'lower') or SVMSCALE(..., L, 'upper', U) 
%   to override the default range [0, 1].   
%
%   SCALED = svmScale(INPUT, 'ranges', RANGES) Scale input data according to 
%   the given ranges.
%
% Author: Paolo D'Apice

opts.lower = 0;
opts.upper = 1;
opts.ranges = [];
opts = vl_argparse(opts, varargin);

if opts.upper <= opts.lower
    error('Bad ranges: lower=%g upper=%g', opts.lower, opts.upper)
end

len = size(input, 1);

if isempty(opts.ranges)
    minima = min(input, [], 1);
    maxima = max(input, [], 1);
    scaled = (opts.upper - opts.lower) ...
             * (input - repmat(minima, len, 1)) ...
             ./ repmat(maxima - minima, len, 1) ...
             + opts.lower;
    ranges = [minima; maxima];
else
    minima = opts.ranges(1, :);
    scaled = (input - repmat(minima, len, 1)) ./ repmat(opts.ranges(2, :) - minima, len, 1);
end
