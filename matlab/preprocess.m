% PREPROCESS Build the visual word vocabulary and compute histograms.
%
%   This script should be executed after checking out the code.

% Author: Paolo D'Apice

clc, clear all

setup

for class = { 'person' }
    classname = char(class);
    vocabulary = buildVocabulary(classname);
    buildHistograms(classname, vocabulary, 'train');
    buildHistograms(classname, vocabulary, 'val');
    buildHistograms('reject', vocabulary', 'val');
end