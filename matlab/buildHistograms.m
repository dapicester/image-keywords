function histograms = buildHistograms(class, vocabulary, varargin)
% BUILDHISTOGRAMS  Compute training histograms.
%
%   HISTOGRAMS = BUILDHISTOGRAMS('CLASS', VOCABULARY) Compute histograms 
%   for images of class CLASS using the given VOCABULARY. 
%   BUILDHISTOGRAMS(..., 'reject') compute histograms on outliers.

% Author: Paolo D'Apice

global DATA_DIR
isReject = (nargin == 3) && strcmp(char(varargin{1}), 'reject');

if isReject
    fprintf('Processing outliers for class %s ...\n', class);
    
    names = textread(fullfile(DATA_DIR, 'reject.txt'), '%s');
    histograms = computeHistogramsFromImageList('reject', vocabulary, names); %#ok<*NASGU>
    
    filename = fullfile(DATA_DIR, [class '_reject_hist.mat']);
else
    fprintf('Processing targets for class %s ...\n', class);
    
    names = textread(fullfile(DATA_DIR, [class '.txt']), '%s');
    histograms = computeHistogramsFromImageList(class, vocabulary, names); %#ok<*NASGU>
    
    filename = fullfile(DATA_DIR, [class '_hist.mat']);
end

save(filename, 'names', 'histograms');
fprintf('Histograms for class %s saved to %s.\n', class, filename);
