function vocabulary = buildVocabulary(class, varargin)
% BUILDVOCABULARY  Build visual word vocabulary.
%   VOCABULARY = BUILDVOCABULARY('NAME') compute vocabulary of visual 
%   words for images in class NAME.
%
%   The function accepts the following options:
%
%   DataDir:: [global DATA_DIR]
%     The directory containing files.
%
%   Force:: [true]
%     Build the vocabulary even if it already exists.

% Author: Paolo D'Apice

global DATA_DIR

conf.dataDir = DATA_DIR;
conf.force = true;
conf = vl_argparse(conf, varargin);

vocabularyFile = fullfile(conf.dataDir, ['vocabulary_' class '.mat']);
if conf.force || ~exist(vocabularyFile, 'file')
    % load image file names
    names = readFileNames(class, conf.dataDir);

    % Use only a (not small) subset of training images
    numImages = 200;
    vocabulary = computeVocabularyFromImageList(class, ...
                        vl_colsubset(names, numImages, 'uniform'));
    % save to file
    save(vocabularyFile, '-struct', 'vocabulary');
    fprintf('Vocabulary for class "%s" saved to %s.\n', class, vocabularyFile);
else
    % load from file
    vocabulary = load(vocabularyFile);
    fprintf('Vocabulary for class "%s" loaded from %s\n', class, vocabularyFile);
end
