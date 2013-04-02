function [keypoints,descriptors] = computeFeatures(im, varargin)
% COMPUTEFEATURES  Compute keypoints and descriptors for an image.
%
%   [KEYPOINTS, DESCRIPTORS] = COMPUTEFEATURES(IM) computes the
%   keypoints and descriptors from the image IM. KEYPOINTS is a 4 x K
%   matrix with one column for keypoint, specifying the X,Y location,
%   the SCALE, and the CONTRAST of the keypoint.
%
%   DESCRIPTORS is a 128 x K matrix of SIFT descriptors of the
%   keypoints.
%
%   The function accepts the following options:
%
%   Step:: [4]
%
%   Scales:: [[4 6 8 10]]
%
% See also: VL_PHOW()

% Author: Andrea Vedaldi
% Author: Paolo D'Apice

conf.step = 4;
conf.scales = [4 6 8 10];
[conf, ~] = vl_argparse(conf, varargin);

im = standardizeImage(im);
[keypoints, descriptors] = vl_phow(im, 'floatdescriptors', true, ...
                                   'step', conf.step, ...
                                   'sizes', conf.scales);
