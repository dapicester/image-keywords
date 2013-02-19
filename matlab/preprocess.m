% PREPROCESS Build visual word vocabulary and compute histograms.
%   TODO: function PREPROCESS('class name')

setup
clear all

%% Compute visual word vocabulary

names{1} = textread('../data/person_train.txt', '%s');
names = cat(1, names{:})';

if ~exist('../data/vocabulary_person.mat', 'file')
    vocabulary = computeVocabularyFromImageList(vl_colsubset(names, 200, 'uniform'));
    save('../data/vocabulary_person.mat', '-struct', 'vocabulary');
    fprintf('Vocabulary saved.\n');
else
    vocabulary = load('../data/vocabulary_person.mat');
    fprintf('Vocabulary loaded\n');
end

%% Compute histograms

for subset = { 'person_train' }
    fprintf('Processing %s ...\n', char(subset));
    names = textread(fullfile('../data', [char(subset) '.txt']), '%s');
    histograms = computeHistogramsFromImageList(vocabulary, names);
    save(fullfile('../data', [char(subset) '_hist.mat']), 'names', 'histograms');
    fprintf('Histograms saved.\n');
end
