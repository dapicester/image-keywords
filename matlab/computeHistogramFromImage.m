function histogram = computeHistogramFromImage(vocabulary, im)
% COMPUTEHISTOGRAMFROMIMAGE  Compute histogram of visual words for an image.
%   HISTOGRAM = COMPUTEHISTOGRAMFROMIMAGE(VOCABULARY, IM) compute the
%   histogram of visual words for image IM given the visual word
%   vocaublary VOCABULARY. To do so the function calls in sequence
%   COMPUTEFEATURES(), QUANTIZEDESCRIPTORS(), and COMPUTEHISTOGRAM().
%
%   See also: COMPUTEVOCABULARYFROMIMAGELIST().

% Author: Andrea Vedaldi
% Author: Paolo D'Apice

if ischar(im)
    im = imread(im);
end

[height, width] = size(im);
[keypoints, descriptors] = computeFeatures(im);
words = quantizeDescriptors(vocabulary, descriptors);
numWords = size(vocabulary.words, 2);
histogram = computeHistogram(width, height, keypoints, words, numWords);
