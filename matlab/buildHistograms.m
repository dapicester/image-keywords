function histograms = buildHistograms(class, vocabulary, varargin)
% BUILDHISTOGRAMS  Compute training histograms.
%
%   HISTOGRAMS = BUILDHISTOGRAMS('CLASS', VOCABULARY) Compute histograms 
%   for images of class CLASS using the given VOCABULARY.
%
%   The function accepts the following options:
%
%   DataDir:: [global DATA_DIR]
%     The directory containing image files.
%
%   SaveDir:: [global DATA_DIR]
%     The directory containing the saved histograms.
%
%   Force:: [true]
%     Compute the histograms if they already exist.
%
%   Reject:: [false]
%     Compute histograms on outliers.

% Author: Paolo D'Apice

global DATA_DIR

conf.dataDir = DATA_DIR;
conf.saveDir = DATA_DIR;
conf.force = false;
conf.reject = false;
conf = vl_argparse(conf, varargin);

if conf.reject
    filename = fullfile(conf.saveDir, [class '_reject_hist.mat']);
    classname = 'reject';
    message = sprintf('Processing outliers for class %s ...', class);
else
    filename = fullfile(conf.saveDir, [class '_hist.mat']);
    classname = class;
    message = sprintf('Processing targets for class %s ...', class);
end

if conf.force || ~exist(filename, 'file')
    % compute
    disp(message)
    histograms = compute(classname);
    save(filename, 'names', 'histograms');
    fprintf('Histograms for class %s saved to %s.\n', class, filename);
else
    % no need to compute
    fprintf('Histograms for class %s already computed in %s.\n', class, filename);
end


function histograms = compute(class)
    names = readFileNames(class, conf.dataDir);
    histograms = computeHistogramsFromImageList(vocabulary, names);
end % compute

end % buildHistograms
