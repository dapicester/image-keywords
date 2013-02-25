function histograms = buildHistograms(class, vocabulary, suffix)
% BUILDHISTOGRAMS  Compute training histograms.
%
%   HISTOGRAMS = BUILDHISTOGRAMS('CLASS', VOCABULARY, 'SUFFIX') Compute 
%   histograms for images of class CLASS in 'SUFFIX' set 
%   using the given VOCABULARY.
%
%   'SUFFIX' can be either 'train' or 'val'

% Author: Paolo D'Apice

fprintf('Processing class %s (%s) ...\n', class, suffix);

names = textread(fullfile('../data', sprintf('%s_%s.txt', class, suffix)), '%s');
histograms = computeHistogramsFromImageList(class, vocabulary, names); %#ok<*NASGU>

filename = fullfile('../data', sprintf('%s_%s_hist.mat', class, suffix));
save(filename, 'names', 'histograms');

fprintf('Histograms for class %s saved to %s.\n', class, filename);
