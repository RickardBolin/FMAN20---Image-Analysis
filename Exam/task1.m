%% Load Image
img = imread('examdata/longbeach.png');

%% Binarize image
img_gray = rgb2gray(img);
img_binary = (img_gray==0);

%% Remove stripes
[m,n] = size(img_binary);
new_img_col = img;

% Label the stripes
black_idxs = bwlabel(img_binary);
L = max(max(black_idxs));
for col = 1:n
    for label = 1:L
        % Find the indexes on column 'col' that are equal to label
        label_idxs = find(black_idxs(:, col)==label);
        if ~isempty(label_idxs)
            % Find where the stripe starts and ends
            first = min(label_idxs);
            last = max(label_idxs);
            if first ~= 1 && last ~= m
                % Linear interpolation on first-1 to last+1 in each color channel c
                for c = 1:3
                    new_img_col(first:last, col, c) = interp1([first-1, last+1], [double(img(first-1, col, c)), double(img(last+1, col, c))], first:last);
                end
            end
        end
    end
end

% Create new binary from the new image (where most of the stripes are removed)
bc = (rgb2gray(new_img_col)==0);

% Repeat what we just did, but this time for rows
black_idxs = bwlabel(img_binary);
L = max(max(black_idxs));
new_img_row = img;
for row = 1:m
    for label = 1:L
        label_idxs = find(img_binary(row, :)==label);
        if ~isempty(label_idxs)
            first = min(label_idxs);
            last = max(label_idxs);
            if first ~= 1 && last ~= n 
                for c = 1:3
                    new_img_row(row, first:last, c) = interp1([first-1, last+1], [double(img(row, first-1, c)), double(img(row, last+1, c))], first:last);
                end
            end
        end
    end
end
br = (rgb2gray(new_img_row)==0);

% Calculate weighted average of the two approximations above
col_w = 0.95;
new_img = col_w*new_img_col + (1-col_w)*new_img_row;

% Fill in the areas that the column/row interpolation could find with column/row value
new_img = new_img + col_w*new_img_row.*uint8(cat(3, bc, bc, bc));
new_img = new_img + (1-col_w)*new_img_col.*uint8(cat(3, br, br, br));

% Quick-fix edges (I doubt anyone will be able to see a single row of pixel on the edge anyway):
new_img(1,:) = new_img(2,:); % Make first row == second row
new_img(end,:) = new_img(end-1,:); % Make last row == second to last row
new_img(:,1) = new_img(:,2); % Make first column == second column
new_img(:,end) = new_img(:,end-1); % Make last column == second to last column

%% Display results
figure
imshow(new_img)
figure
imshow(img)

%% Try to make the interpolated values melt in better by adding Gaussian noise
% Include area around stripe in binary
b = img_binary;
se = strel('disk', 5, 6);
d = imdilate(b, se);

% Extract the area on and around the stripe, smooth it and then add noise to it
new_img_noise = new_img;
new_img_noise(~cat(3, d, d, d)) = 0;
new_img_noise = imfilter(new_img_noise, ones(5)/5^2);
for i = 1:3
    new_img_noise(:,:,i) = imnoise(new_img_noise(:,:,i),'gaussian', 0, 0.0005);
end

% Replace the stripe with the new noisy stripe
new_blurred_img = new_img.*(abs(1-uint8(cat(3, b, b, b)))) + new_img_noise.*uint8(cat(3, b, b, b));
imshow(new_blurred_img)

%% Contrast stretch image
% Find the maximum amount we can contrast stretch the image
lowhigh = stretchlim(new_blurred_img);
% Stretch contrast, gamma = 1.3 to make image a little bit darker
img_improved = imadjust(new_blurred_img,lowhigh,[], 1.3);
