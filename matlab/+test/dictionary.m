function [resultsA, resultsB] = dictionary(classname, dirA, dirB, numRun)
% DICTIONARY  Test1: global vs per-class PHOW dictionary.

% Author: Paolo D'Apice

% a. per-class dictionary
disp('Using per-class dictionary')
datasetA = test.loadDatasets(classname, dirA, numRun);
resultsA = test.runClassification(classname, datasetA, numRun);

% b. global dictionary
disp('Using global dictionary')
datasetB = test.loadDatasets(classname, dirB, numRun);
resultsB = test.runClassification(classname, datasetB, numRun);
