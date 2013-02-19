% Build the visual word vocabulary and compute histograms.

clc, clear all

setup

for class = { 'person' }
    vocabulary = buildVocabulary(char(class));
    computeTrainingHistograms(char(class), vocabulary);
end
