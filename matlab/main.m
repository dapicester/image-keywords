% MAIN  Train and test a classifier.

% Author: Paolo D'Apice

clear all
setup

for class = { 'animal', 'cellphone', 'face', 'person' }
    classname = char(class);
    % repeat N times and get average results
    results = runClassification(classname);
    % show results
    showResults(classname, results);
    
    disp('Press a key to continue with next class, CTRL-C to quit'), pause
end
