function out = hellingerKernel(x, y)
% HELLINGERKERNEL  Compute the Hellinger kernel.
%   OUT = HELLINGERKERNEL(X, Y)  Compute the Hellinger kernel defined as:
%
%     K(X, Y) = Sum sqrt(X_i * Y_i)
%                i

%sx = sqrt(x);
%sy = sqrt(y);
%norm = @(a) bsxfun(@times, a, 1./(sum(a,2) + eps));
%out = norm(sx) * norm(sy)';
out = sqrt(x) * sqrt(y)';
