function histograms = buildHistograms(class, vocabulary, varargin)
% BUILDHISTOGRAMS  Compute training histograms.
%
%   HISTOGRAMS = BUILDHISTOGRAMS('CLASS', VOCABULARY) Compute histograms 
%   for images of class CLASS using the given VOCABULARY.
%
%   The function accepts the following options:
%
%   DataDir:: [global DATA_DIR]
%     The directory containing files.
%
%   Reject:: [false]
%     Compute histograms on outliers.

% Author: Paolo D'Apice

global DATA_DIR

conf.dataDir = DATA_DIR;
conf.reject = false;
conf = vl_argparse(conf, varargin);

if conf.reject
    fprintf('Processing outliers for class %s ...\n', class);
    [names, histograms] = compute(vocabulary, 'reject', conf.dataDir); %#ok<ASGLU>
    filename = fullfile(conf.dataDir, [class '_reject_hist.mat']);
else
    fprintf('Processing targets for class %s ...\n', class);
    [names, histograms] = compute(vocabulary, class, conf.dataDir); %#ok<ASGLU>
    filename = fullfile(conf.dataDir, [class '_hist.mat']);
end

save(filename, 'names', 'histograms');
fprintf('Histograms for class %s saved to %s.\n', class, filename);


function [names, histograms] = compute(vocabulary, class, dir)
names = readFileNames(class, dir);
histograms = computeHistogramsFromImageList(vocabulary, names);
