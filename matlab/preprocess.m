% PREPROCESS Build the visual word vocabulary and compute histograms.
%
%   This script should be executed after checking out the code.

% Author: Paolo D'Apice

clc, clear all
setup

force = false;

for class = { 'animal', 'cellphone', 'face', 'person' }
    classname = char(class);
    vocabulary = buildVocabulary(classname, force);
    buildHistograms(classname, vocabulary);
    buildHistograms(classname, vocabulary, 'reject');
end
