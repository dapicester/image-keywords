function names = readFileNames(class, dataDir)
% READFILENAMES  Read file names from file.
%   NAMES = READFILENAMES(CLASS, DIR)
    names = textread(fullfile(dataDir, [class '.txt']), '%s');
    names = cellfun(@(name) fullfile(dataDir, class, name), names, ...
                    'UniformOutput', false);
end
