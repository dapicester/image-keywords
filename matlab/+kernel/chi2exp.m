function out = chi2exp(x, y, varargin)
% CHI2EXP  Compute the exponential chi-square kernel.
%   OUT = KERNEL.CHI2EXP(X,Y)  Compute the exponential chi-square kernel
%   defined as:
%
%      K(X,Y) = exp(-gamma * chi2(X, Y))
%
%   where
%                       (x_i - y_i)^2
%      chi2(X,Y) =  Sum -------------
%                    i   (x_i + y_i)
% 
%   Use KERNEL.CHI2EXP(..., GAMMA) to override the default value of
%   1/num_features.

% Author: Paolo D'Apice

if nargin == 2
    gamma = 1/size(x,2);
else
    gamma = varargin{1};
end

out = zeros(size(x, 1), size(y, 1));
for i = 1 : size(y, 1)
    num = bsxfun(@minus, x, y(i,:));
    den = bsxfun(@plus, x, y(i,:));
    out(:,i) = sum(num.^2 ./ (den + eps), 2);
end
out = exp(-gamma * out);
