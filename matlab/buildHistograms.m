function histograms = buildHistograms(class, vocabulary, suffix)
% BUILDHISTOGRAMS  Compute training histograms.
%
%   HISTOGRAMS = BUILDHISTOGRAMS('CLASS', VOCABULARY, 'SET') Compute 
%   histograms for images of class CLASS in 'SET' using the given 
%   VOCABULARY. 
%   Sets are defined in text files named 'CLASS_SET.txt'.
%   'SET' can be either 'train' or 'val'

% Author: Paolo D'Apice

global DATA_DIR
isReject = strcmp(suffix, 'reject');

fprintf('Processing class %s (%s) ...\n', class, suffix);

if isReject
    filename = 'reject_val.txt';
    names = textread(fullfile(DATA_DIR, filename), '%s');
    histograms = computeHistogramsFromImageList('reject', vocabulary, names); %#ok<*NASGU>
else
    filename = sprintf('%s_%s.txt', class, suffix);
    names = textread(fullfile(DATA_DIR, filename), '%s');
    histograms = computeHistogramsFromImageList(class, vocabulary, names); %#ok<*NASGU>
end

filename = fullfile(DATA_DIR, sprintf('%s_%s_hist.mat', class, suffix));
save(filename, 'names', 'histograms');

fprintf('Histograms for class %s saved to %s.\n', class, filename);
