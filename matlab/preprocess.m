% PREPROCESS Build the visual word vocabulary and compute histograms.
%
%   This script should be executed only once after checking out the code.

clc, clear all

setup

for class = { 'person' }
    classname = char(class);
    vocabulary = buildVocabulary(classname);
    buildHistograms(classname, vocabulary, 'train');
    buildHistograms(classname, vocabulary, 'val');
    buildHistograms('reject', vocabulary', 'val');
end