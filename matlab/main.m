% MAIN  Train and test a classifier.

% Author: Paolo D'Apice

clear all
setup

for class = { 'animal', 'cellphone', 'face', 'person' }
    % repeat N times and get average results
    N = 10;
    results = cell(N,1);
    for i = 1:N
        results{i} = classify(char(class));
    end
    results = struct2dataset(cell2mat(results));
    
    fprintf('----------------------------\n');
    fprintf('  Average accuracy : %f\n', mean(results.accuracy))
    fprintf('  Average precision: %f\n', mean(results.precision))
    fprintf('  Average recall   : %f\n', mean(results.recall))
    fprintf('----------------------------\n');
    
    disp('Press a key to continue with next class, CTRL-C to quit'), pause
end
