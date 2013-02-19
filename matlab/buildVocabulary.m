function vocabulary = buildVocabulary(class)
% BUILDVOCABULARY  Build visual word vocabulary.
%
%   vocabulary = BUILDVOCABULARY('NAME') compute vocabulary for images
%   in class NAME.

names{1} = textread(fullfile('../data', [class '_train.txt']), '%s');
names = cat(1, names{:})';

vocabularyFile = fullfile('../data', ['vocabulary_' class '.mat']);
if ~exist(vocabularyFile, 'file')
    vocabulary = computeVocabularyFromImageList(class, vl_colsubset(names, 200, 'uniform'));
    save(vocabularyFile, '-struct', 'vocabulary');
    fprintf('Vocabulary for class "%s" saved to %s.\n', class, vocabularyFile);
else
    vocabulary = load(vocabularyFile);
    fprintf('Vocabulary for class "%s" loaded from %s\n', class, vocabularyFile);
end
