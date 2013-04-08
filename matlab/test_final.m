% TEST_FINAL  Train and test a classifier.

% Author: Paolo D'Apice

clear all
setup

%% configurations

config = cellfun(@(c) cell2struct(c, {'id' 'class', 'kernel', 'nu'}, 2), ...
    {  
        { 1 'bag', @kernel.linear, 0.05 }, ...
        { 2 'shoes', @kernel.linear, 0.03 }, ...
    });
numConfig = numel(config);

N = 1;

%% run

results = cell(numConfig, 1);
for i = 1:numConfig
    cfg = config(i);
    datasets = test.loadDatasets(cfg.class, DATA_DIR, N);
    results{i} = runClassification(cfg.class, datasets, N, ...
                                   cfg.kernel, ...
                                   'nu', cfg.nu, ...
                                   'verbose', true, ...
                                   'testpc', true, 'testrank', true ...
                               );
    
    % show results
%     showResults(classname, results);
    
    if cfg.id ~= config(end).id
        disp('Press a key to continue with next class, CTRL-C to quit'), 
        pause
    end
end
clear cfg dataset