% PREPROCESS Build the visual word vocabulary and compute histograms.
%
%   This script should be executed after checking out the code.

% Author: Paolo D'Apice

clc, clear all
setup

force = false;

for class = { 'person', 'face', 'animal' }
    classname = char(class);
    vocabulary = buildVocabulary(classname, force);
    buildHistograms(classname, vocabulary, 'train');
    buildHistograms(classname, vocabulary, 'val');    
    buildHistograms(classname, vocabulary, 'reject');
end
