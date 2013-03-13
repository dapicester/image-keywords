function vocabulary = loadVocabulary(class)
% LOADVOCABULARY  Load visual word vocabulary.

% Author: Paolo D'Apice

global DATA_DIR

vocabulary = load(fullfile(DATA_DIR, sprintf('vocabulary_%s.mat', class)));
