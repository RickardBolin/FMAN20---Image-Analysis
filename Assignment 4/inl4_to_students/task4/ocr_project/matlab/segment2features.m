function features = segment2features(I)

I = crop(I);
[m,n] = size(I);

% Features 9-72: Split the image into 64 regions and check if there is more
% black or white
parts = [];
imgsplit = split4(I);
for i = 1:4
    p_mid = split4(imgsplit{i});
    for j = 1:4
        p = split4(p_mid{j});
        parts(end+1 : end+4) =  [mean(mean(p{1})), mean(mean(p{2})), mean(mean(p{3})),mean(mean(p{4}))];
    end
end

features = zeros(8 + 64,1);

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
bot_mid_r = min(round(mean(r)*1.4), n-1);
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

features(9:8+64) = (parts > 0.5);

end

function I_crop = crop(I)
    [rows, cols] = find(I);
    I_crop = I(min(rows):max(rows), min(cols):max(cols));
end

function parts = split4(I)
    p1 = I(1:floor(end/2), 1:floor(end/2));
    p2 = I(1:floor(end/2), floor(end/2)+1:end);
    p3 = I(floor(end/2)+1:end, 1:floor(end/2));
    p4 = I(floor(end/2)+1:end, floor(end/2)+1:end);
    parts = {p1, p2, p3, p4};
end