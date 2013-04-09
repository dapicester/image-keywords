function out = getDescriptors(data, descriptors)
% GETDESCRIPTORS  Pick descriptors from data ('phow', 'phog' or 'both').

% Author: Paolo D'Apice

values = struct2cell(data);

% only one descriptor available
if size(values,1) == 1
    out = cat(1, values{:});
    return
end

% both available, select
switch descriptors
    case 'phow', 
        phow = values(1,:,:);
        out = cat(1, phow{:});
    case 'phog'
        phog = values(2,:,:);
        out = cat(1, phog{:});
    case 'both'
        phow = values(1,:,:);
        phog = values(2,:,:);
        out = [cat(1, phow{:}), cat(1, phog{:})];
    otherwise
        error('%s not available', descriptors);
end
