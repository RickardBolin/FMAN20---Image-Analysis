% Task 1: Fit least squares and total least squares lines to data points.

% Clear up
%clc;
%close all;
%clearvars;

% Begin by loading data points from linjepunkter.mat
load linjepunkter
%x = x_test';
%y = y_test';
N = length(x); % number of data points

% Plot data
plot(x, y, '*'); hold on;
xlabel('x') 
ylabel('y')
title('Lines fitted to data using LS and TLS', 'FontSize', 18) % OBS - CHANGE TITLE!
x_fine = [min(x)-0.05,max(x)+0.05]; % used when plotting the fitted lines

% Fit a line to these data points with least squares
% Here you should write code to obtain the p_ls coefficients (assuming the
% line has the form y = p_ls(1) * x + p_ls(2)).
p_ls = [x, ones(size(x))]\y;
plot(x_fine, p_ls(1) * x_fine + p_ls(2))

% Fit a line to these data points with total least squares.
% Note that the total least squares line has the form 
% ax + by + c = 0, but the plot command requires it to be of the form
% y = kx + m, so make sure to convert appropriately.

[ab, lambdas] = eig([sum(x.^2) - (1/N)*sum(x)^2, sum(x.*y) - (1/N)*sum(x)*sum(y);
               sum(x.*y) - (1/N)*sum(x)*sum(y), sum(y.^2) - (1/N)*sum(y)^2]);
c = -(1/N)*(ab(:,1)*sum(x) + ab(:,2)*sum(y));
errors = zeros(2,1);
for i = 1:2
    errors(i) = sum((abs(ab(1,i)*x + ab(2,i)*y + c(i))/(sqrt(ab(1, i)^2 + ab(2, i)^2))).^2);
end
[~, idx] = min(errors);
c = c(idx);
ab = ab(:, idx);
p_tls = [-(ab(1)/ab(2)), -c/ab(2)];
plot(x_fine, p_tls(1) * x_fine + p_tls(2), 'k--')

% Legend --> show which line corresponds to what (if you need to
% re-position the legend, you can modify rect below)
h=legend('data points', 'least-squares','total-least-squares');
rect = [0.20, 0.65, 0.25, 0.25];
set(h, 'Position', rect)
h.FontSize = 14;

% After having plotted both lines, it's time to compute errors for the
% respective lines. Specifically, for each line (the least squares and the
% total least squares line), compute the least square error and the total
% least square error. Note that the error is the sum of the individual
% errors for each data point! In total you should get 4 errors. Report these
% in your report, and comment on the results. OBS: Recall the distance formula
% between a point and a line from linear algebra, useful when computing orthogonal
% errors!

% WRITE CODE BELOW TO COMPUTE THE 4 ERRORS
% For LS-line:
ls_error_1 = sum((y - (p_ls(1)*x + p_ls(2))).^2);
tls_error_1 = sum((abs(-p_ls(1)*x + y + -p_ls(2))/(sqrt(p_ls(1)^2 + 1))).^2);

% For TLS-line:
ls_error_2 = sum((y - (p_tls(1)*x + p_tls(2))).^2);
tls_error_2 = sum((abs(ab(1)*x + ab(2)*y + c)/(sqrt(ab(1)^2 + ab(2)^2))).^2);
