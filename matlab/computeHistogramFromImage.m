function histogram = computeHistogramFromImage(vocabulary, im)
% COMPUTEHISTOGRAMFROMIMAGE  Compute histograms for an image.
%
%   HISTOGRAM = COMPUTEHISTOGRAMFROMIMAGE(VOCABULARY, IM) compute the
%   histogram of visual words (PHOW) and the histogram of oriented 
%   gradients (PHOG) for image IM. The visual word vocabulary VOCABULARY
%   is used to compute visual words.
%
%   See also: COMPUTEVOCABULARYFROMIMAGELIST().

% Author: Andrea Vedaldi
% Author: Paolo D'Apice

if ischar(im)
    im = imread(im);
end

% TODO: standardize image before phow and phog 

% PHOW
[height, width] = size(im);
[keypoints, descriptors] = computeFeatures(im);
words = quantizeDescriptors(vocabulary, descriptors);
numWords = size(vocabulary.words, 2);
histogram.words = computeHistogram(width, height, keypoints, words, numWords);

% PHOW
histogram.gradients = computeGradients(im);
