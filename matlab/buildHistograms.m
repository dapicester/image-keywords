function buildHistograms(class, vocabulary, varargin)
% BUILDHISTOGRAMS  Compute training histograms.
%
%   BUILDHISTOGRAMS('CLASS', VOCABULARY) Compute histograms 
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
%   The function forwards any other unknown option.
%
% See also: PRIVATE/COMPUTEHISTOGRAMSFROMIMAGELIST()

% Author: Paolo D'Apice

global DATA_DIR

conf.dataDir = DATA_DIR;
conf.saveDir = DATA_DIR;
conf.force = false;
[conf, varargin] = vl_argparse(conf, varargin);

filename = fullfile(conf.saveDir, [class '_hist.mat']);


if conf.force || ~exist(filename, 'file')
    fprintf('Processing images in class %s ...\n', class);
    names = readFileNames(class, conf.dataDir);
    histograms = computeHistogramsFromImageList(vocabulary, names, varargin{:}); %#ok<NASGU>
    save(filename, 'names', 'histograms');
    fprintf('Histograms for class %s saved to %s.\n', class, filename);
else
    % no need to compute
    fprintf('Histograms for class %s already computed in %s.\n', class, filename);
end
