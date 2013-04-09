% DEMO  Image Retrieval Demo.

% Author: Paolo D'Apice

clc, clear all
setup

% the labels we want to assign
classes = { 'bag', 'shoes' };

% unlabeled images
dataDir = fullfile(DATA_DIR, 'demo');

% run the demo
data = runDemo(dataDir, classes);
