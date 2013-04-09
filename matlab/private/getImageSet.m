function names = getImageSet(path)
% GETIMAGESET  Scan a directory for images
%
%   NAMES = GETIMAGESET(PATH)  Scans PATH for JPG, PNG, JPEG, GIF,
%   BMP, and TIFF files and returns their path into NAMES.

% Author: Andrea Vedaldi
% Author: Paolo D'Apice

content = dir(path);
if isempty(content)
    warning('No files in %s', path);
    names = {};
    return
end

names = {content.name};
ok = regexpi(names, '.*\.(jpg|png|jpeg|gif|bmp|tiff)$', 'start');
names = names(~cellfun(@isempty,ok));

for i = 1:length(names)
    names{i} = fullfile(path,names{i});
end
