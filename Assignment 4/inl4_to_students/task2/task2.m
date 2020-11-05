load('task2/heart_data.mat')
I = im;

[M, N] = size(I);
n = M*N;

% (1): Estimate the mean and the standard deviation for the background and
% chamber distributions.
mu0 = mean(background_values);
sigma0 = std(background_values);
mu1 = mean(chamber_values);
sigma1 = std(chamber_values);

P1 = @(x) normpdf(x, mu0, sigma0);
P2 = @(x) normpdf(x, mu1, sigma1);

log_cost_P1 = @(x) -log(P1(x)); 
log_cost_P2 = @(x) -log(P2(x));

lambda = 5.5;

Neighbors = edges4connected(M,N);
i=Neighbors(:,1);
j=Neighbors(:,2);
A = sparse(i,j,lambda,n,n);

% (3): Manually set the last ~20 rows to "Not chambers"
I(75:end, :) = 1e6;

T = [log_cost_P1(I(:)) log_cost_P2(I(:))];
T = sparse(T);

[~, Theta] = maxflow(A,T);
Theta = reshape(Theta,M,N);
Theta = double(Theta);

imshow(Theta)
%%
overlay = imoverlay(im, abs(1-Theta), 'red');
imshow(overlay)
