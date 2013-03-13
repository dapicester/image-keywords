function params = gridOneSVM(labels, data, kernel, varargin)
% GRIDONESVM  Grid search for one-class SVM parameter selection.
%   PARAMS = GRIDONESVM(LABELS, DATA, KERNEL)  Perform a grid search 
%   on the parameters space using the given DATA and KERNEL. 
%   The objective function is: min sqrt( (n-fsv)^2 + (n-fout)^2 )
%   where fsv and fout are respectively the fraction of support vectors
%   and the fraction of outliers.
%
%   Use GRIDONESVM(..., 'n', VALUES) to specify values of nu for the 
%   one-class SVM formulation.
% 
%   PARAMS is a data structure containing the fields 'bestn' and
%   'bestobj' containing respectively the best nu and objective function
%   value.

% Author: Paolo D'Apice

opts.n = [ 0.01, 0.03, 0.05, 0.1, 0.15, 0.2, 0.3, 0.5, 0.8 ];
%opts.log2g = -15:2:5;
opts = vl_argparse(opts, varargin);

numVectors = size(data, 1);
params.bestobj = Inf;

%for log2g = opts.log2g

% precompute kernel
train = precomputeKernel(kernel, data);

for n = opts.n
        % train model
        options = [ '-s 2 -t 4 -q -n ', num2str(n) ]; %, ' -g ', num2str(2^log2g)];
        model = trainOneSVM(labels, train, options);

        % compute objective function
        predicted = predictSVM(labels, train, model);
        fsv = model.totalSV / numVectors;
        fout = numel(find(predicted == -1)) / numVectors;
        obj = objective(n, fsv, fout);
        
        % evaluate
        if (obj < params.bestobj)
            params.bestobj = obj;
            params.bestn = n;
            %params.bestg = 2^log2g;
            fprintf('*')
        else
            fprintf('.')
        end
        %fprintf('-> %g %g %g (best n=%g, g=%g, rate=%g)\n', ...
        %        n, log2g, cv, params.bestn, params.bestg, params.bestcv);
        fprintf(' %.2f  %.6f\t(best n=%.2f  obj=%.6f)\n', ...
                n, obj, params.bestn, params.bestobj);
end
%end


function o = objective(n, fsv, fout)
% OBJECTIVE  Compute the objective function.
o = sqrt( (n-fsv)^2 + (n-fout)^2 );