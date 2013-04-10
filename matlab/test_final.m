% TEST_FINAL  Train and test a classifier on random datatasets.

% Author: Paolo D'Apice

clear all
setup

%% configurations

config = cellfun(@(c) cell2struct(c, {'id', 'class', 'kernel', 'nu'}, 2), ...
    {
        { 1 'bag', @kernel.linear, 0.05 }, ...
        { 2 'shoes', @kernel.linear, 0.03 }, ...
    });
numConfig = numel(config);

%% run

for i = 1:numConfig
    cfg = config(i);
    fprintf(' * Classifying images in class "%s"\n', cfg.class)
    
    [train, val] = loadData(cfg.class);
    classify(train, val, cfg.kernel, 'nu', cfg.nu, ...
             'verbose', true, 'showpc', true, 'testrank', true);
        
    if cfg.id ~= config(end).id
        fprintf('\nPress a key to continue with next class, CTRL-C to quit\n\n')
        pause
    end
end
clear cfg train val
