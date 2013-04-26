function out = chi2(x, y, varargin)
% CHI2  Compute the chi-square kernel.
%   OUT = KERNEL.CHI2(X,Y)  Compute the normal chi-square kernel
%   defined as:
%                        x_i * y_i
%      K(X,Y) = 2 * Sum -----------
%                    i   x_i + y_i

% Author: Paolo D'Apice

out = zeros(size(x, 1), size(y, 1));
for i = 1 : size(y, 1)
    num = 2 * bsxfun(@times, x, y(i,:));
    den = bsxfun(@plus, x, y(i,:));
    out(:,i) = sum(num./(den + eps), 2);
end
