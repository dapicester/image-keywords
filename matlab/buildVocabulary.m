function vocabulary = buildVocabulary(class)
% BUILDVOCABULARY  Build visual word vocabulary.
%
%   vocabulary = BUILDVOCABULARY('NAME') compute vocabulary for images
%   in class NAME.

% Author: Paolo D'Apice

global DATA_DIR

names{1} = textread(fullfile(DATA_DIR, [class '_train.txt']), '%s');
names = cat(1, names{:})';

numImages = 200;

vocabularyFile = fullfile(DATA_DIR, ['vocabulary_' class '.mat']);
if ~exist(vocabularyFile, 'file')
    vocabulary = computeVocabularyFromImageList(class, ...
                        vl_colsubset(names, numImages, 'uniform'));
    save(vocabularyFile, '-struct', 'vocabulary');
    fprintf('Vocabulary for class "%s" saved to %s.\n', class, vocabularyFile);
else
    vocabulary = load(vocabularyFile);
    fprintf('Vocabulary for class "%s" loaded from %s\n', class, vocabularyFile);
end
