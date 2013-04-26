function out = histint(x, y)
% HISTINT  Histogram intersection kernel.
%   OUT = KERNEL.HISTINT(X, Y)  Compute the kernel defined as:
%
%   K(X, Y) = Sum min(X_i, Y_i) = 0.5 * Sum ( X_i + Y_i - |X_i - Y_i| )
%              i                         i

% Author: Paolo D'Apice

n = size(x, 1);
m = size(y, 1);
out = zeros(n, m);
for i = 1 : m
    t = repmat(y(i,:), n, 1);
    out(:,i) = 0.5 * sum(t + x - abs(t - x), 2);
end
