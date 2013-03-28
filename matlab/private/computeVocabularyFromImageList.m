function vocabulary = computeVocabularyFromImageList(class, names, varargin)
% COMPUTEVOCABULARYFROMIMAGELIST  Compute a visual word vocabulary.
%   VOCABULARY = COMPUTEVOCABULARYFROMIMAGELIST('CLASS', NAMES) computes a
%   visual word vocabulary from a list of image names (paths) NAMES
%   belonging to the class CLASS.
%
%   VOCABULARY is a structure with fields:
%     WORDS:: 128 x K matrix of visual word centers.
%     KDTREE:: KD-tree indexing the visual word for fast quantization.
%     CLASS:: the class name.
%
%   The function accepts the following options:
%
%   NumWords:: [300]
%     The number of visual words.

% Author: Andrea Vedaldi
% Author: Paolo D'Apice

conf.numWords = 300;
conf = vl_argparse(conf, varargin);

% This extracts a number of visual descriptors from the specified images. 
% Only NUMFEATURES overall descriptors are retrieved as more do not really
% improve the estimation of the visual dictionary but slow down computation.

len = numel(names);
descriptors = cell(1, len);
numFeatures = round(conf.numWords * 100 / len);
parfor i = 1:len
    fullPath = names{i};
    fprintf('  Extracting features from %s (%d/%d)\n', fullPath, i, len);
    im = imread(fullPath);
    [~, d] = computeFeatures(im);
    descriptors{i} = vl_colsubset(d, numFeatures, 'uniform');
end

% This clusters the descriptors into NUMWORDS visual words by using KMEANS.
% It then computes a KDTREE to index them. 
% The use of a KDTREE is optional, but speeds-up quantization significantly.

fprintf('Computing visual words and kdtree ...\n');
descriptors = single([descriptors{:}]);
vocabulary.words = vl_kmeans(descriptors, conf.numWords, 'algorithm', 'elkan', 'verbose');
vocabulary.kdtree = vl_kdtreebuild(vocabulary.words, 'verbose');
vocabulary.class = class;
