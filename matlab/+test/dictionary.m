function [resultsA, resultsB] = dictionary(classname, dirA, dirB, numRun)
% DICTIONARY  Test1: global vs per-class PHOW dictionary.

% Author: Paolo D'Apice

% a. per-class dictionary classification
datasetA = test.loadDatasets(classname, dirA, numRun);
resultsA = test.runClassification(classname, datasetA, numRun);

% b. global dictionary classification
datasetB = test.loadDatasets(classname, dirB, numRun);
resultsB = test.runClassification(classname, datasetB, numRun);
