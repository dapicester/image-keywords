function vocabulary = buildVocabulary(class, varargin)
% BUILDVOCABULARY  Build visual word vocabulary.
%
%   vocabulary = BUILDVOCABULARY('NAME') compute vocabulary for images
%   in class NAME if not found.
%   Use BUILDVOCABULARY(..., true) to overwrite an existing
%   vocabulary.

% Author: Paolo D'Apice

force = false;
if (nargin == 2)
    force = varargin{1};
end

global DATA_DIR

names{1} = textread(fullfile(DATA_DIR, [class '.txt']), '%s');
names = cat(1, names{:})';

% Use only a subset of training images
numImages = 50;

vocabularyFile = fullfile(DATA_DIR, ['vocabulary_' class '.mat']);
if ~exist(vocabularyFile, 'file') | force
    vocabulary = computeVocabularyFromImageList(class, ...
                        vl_colsubset(names, numImages, 'uniform'));
    save(vocabularyFile, '-struct', 'vocabulary');
    fprintf('Vocabulary for class "%s" saved to %s.\n', class, vocabularyFile);
else
    vocabulary = load(vocabularyFile);
    fprintf('Vocabulary for class "%s" loaded from %s\n', class, vocabularyFile);
end
