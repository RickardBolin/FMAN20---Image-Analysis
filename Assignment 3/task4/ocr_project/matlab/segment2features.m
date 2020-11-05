function features = segment2features(I)

I = crop(I);
features = zeros(8,1);
[m,n] = size(I);

% Feature 1 - Euler number (number of objects - number of holes)
features(1) = bweuler(I);

% Feature 2 - Proportion of white pixels in image
features(2) = sum(I, 'all')/(m*n);

% Feature 3 - Proportion of white pixel enclosed by object
features(3) = sum(imfill(I, 'holes'), 'all')/(m*n);

% Feature 4 - Number of intersections of 3-pixel-wide horizontal line
% through top part of image
[r, ~] = find(I==1);
top_mid_r =  max(round(mean(r)*0.5), 2);
features(4) = max(bwlabel(I(top_mid_r-1:top_mid_r+1,:), 8),[], 'all');

% Feature 5 - Number of intersections of 3-pixel-wide horizontal line
% through bot part of image
[r, ~] = find(I==1);
bot_mid_r = min(round(mean(r)*1.5), n-1);
features(5) = max(bwlabel(I(bot_mid_r-1:bot_mid_r+1,:), 8),[], 'all');

% Feature 6 - Number of intersections of 3-pixel-wide vertical line through image COG
[~, c] = find(I==1);
mid_c = round(mean(c));
features(6) = max(bwlabel(I(:, mid_c-1:mid_c+1), 8),[], 'all');

% Feature 7 - Number of intersections of 3-pixel-wide vertical line
% through left part of image
[~, c] = find(I==1);
left_mid_c = max(round(mean(c)*0.5), 2);
features(7) = max(bwlabel(I(:,left_mid_c-1:left_mid_c+1), 8),[], 'all');

% Feature 8 - Number of intersections of 3-pixel-wide vertical line
% through right part of image
[~, c] = find(I==1);
[~, n] = size(I);
right_mid_c = min(round(mean(c)*1.5), n-1);
features(8) = max(bwlabel(I(:, right_mid_c-1:right_mid_c+1), 8),[], 'all');

end

function I_crop = crop(I)
    [rows, cols] = find(I);
    I_crop = I(min(rows):max(rows), min(cols):max(cols));
end