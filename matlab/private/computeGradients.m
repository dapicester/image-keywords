function histogram = computeGradients(im, varargin)
% COMPUTEGRADIENTS  Compute histogram of gradients.
%
%   HISTOGRAM = COMPUTEGRADIENTS(IM) computes the PHOG from the image IM.
%
%   See also: ANNA_PHOG

% Author: Andrea Vedaldi

im = standardizeImage(im);
histogram = anna_phog(im, varargin{:}, 'levels', 2);
