function histograms = computeTrainingHistograms(class, vocabulary)
% COMPUTETRAININGHISTOGRAMS  Compute training histograms.
%
%   HISTOGRAMS = COMPUTETRAININGHISTOGRAMS('CLASS', VOCABULARY) Compute 
%   histograms for images of class 'CLASS' using the given VOCABULARY.

fprintf('Processing class %s ...\n', class);
names = textread(fullfile('../data', [class '_train.txt']), '%s');
histograms = computeHistogramsFromImageList(vocabulary, names); %#ok<*NASGU>
save(fullfile('../data', [class '_hist.mat']), 'names', 'histograms');
fprintf('Histograms for class %s saved.\n', class);
