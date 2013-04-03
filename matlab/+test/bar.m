function h = bar(data, error)
% BAR  Bar graph with errorbars.
% http://www.mathworks.it/support/solutions/en/data/1-18H2E/?solution=1-18H2E

% Author: Paolo D'Apice

h = bar(data);
set(h, 'BarWidth', 1); % The bars will now touch each other

numgroups = size(data, 1);
numbars = size(data, 2);
groupwidth = min(0.8, numbars/(numbars+1.5));

hold on;
for i = 1:numbars
    % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
    x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars); % Aligning error bar with individual bar
    errorbar(x, data(:,i), error(:,i), 'r', 'linestyle', 'none');
end
hold off
