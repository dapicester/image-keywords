function out = hellinger(x, y)
% HELLINGER  Compute the Hellinger kernel.
%   OUT = KERNEL.HELLINGER(X, Y)  Compute the Hellinger kernel defined as:
%
%     K(X, Y) = Sum sqrt(X_i * Y_i)
%                i

out = sqrt(x) * sqrt(y)';
