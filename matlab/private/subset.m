function ind = subset(data, len)
% SUBSET  Return logical indices of a subset of LEN rows of the input DATA.

% Author: Paolo D'Apice

numData = size(data, 2);
len = min(numData, len);
perm = randperm(numData);
ind = false(1, numData);
ind(sort(perm(1:len))) = true;
