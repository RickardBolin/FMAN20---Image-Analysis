%% Load image
img = imread('examdata/dots.jpg');

%% Binarize Image
img_binary = imbinarize(rgb2gray(img));

%% Remove black patches larger than dots and numbers (with some margin)

clean = bwlabel(abs(img_binary-1));
while sum(clean==mode(clean, 'all'), 'all') > 150
    % Find the most common number and set all of those to NaN
    clean(clean==mode(clean, 'all')) = NaN;
end
img_binary_cleaned = img_binary;
img_binary_cleaned(isnan(clean)) = 1;

imshow(img_binary_cleaned)

%% Build dot shaped filter with size 13x13, center in (7,7) and radius 5.9
x1 = 5.9 * cos(linspace(0, 2*pi)) + 7;
y1 = 5.9 * sin(linspace(0, 2*pi)) + 7;
% 1 on the dot, -2 outside to make sure lines doesn't get marked as dots
filter = 3*poly2mask(x1, y1, 13, 13)-2;
imshow(filter)
%% Convolve filter and image and extract center points for dots
conv_res = conv2(abs(img_binary_cleaned-1), filter, 'same');

% Extract center points of all dots found in the image
center_points = [];
center_points_img = zeros(size(img_binary_cleaned));
while max(conv_res(:)) > 80
    [~, max_idx] = max(conv_res(:));
    [x,y] = ind2sub(size(conv_res), max_idx(1));
    center_points = [center_points; [x, y]];
    % Set area around the extracted point to zero in conv_res
    conv_res(x-7:x+7, y-7:y+7) = 0;
    center_points_img(x-7:x+7, y-7:y+7) = 1;
end
nb_dots = length(center_points);

% Show center points and surrounding area 
center_point_overlay = imoverlay(img_binary_cleaned, center_points_img, 'red');
imshow(center_point_overlay)

%% Remove the segmented from binary image to make OCR easier
img_binary_cleaned = img_binary_cleaned + center_points_img;
img_binary_cleaned(img_binary_cleaned == 2) = 1;

% Show clean image with only numbers
imshow(img_binary_cleaned)

%% Perform OCR
% Use 'Auto'-layout for 2-digit numbers and 'Block'-layout for 1 digit numbers
results_2digit = ocr(img_binary_cleaned, 'CharacterSet','0123456789', 'TextLayout','Auto');
results_1digit = ocr(img_binary_cleaned, 'CharacterSet','0123456789', 'TextLayout','Block');

%% Extract positions for numbers 1 to the number of dots found
digit_mid_points = zeros(nb_dots, 2);
digit_mid_points_img = zeros(size(img_binary));
results = results_1digit;
for digit = 1:nb_dots
    if digit == 10
        results = results_2digit;
    end
    for cell = 1:length(results.Words)
        if strcmp(results.Words{cell}, int2str(digit))
            pos = results.WordBoundingBoxes(cell,:);
            x = round(pos(2) + pos(4)/2);
            y = round(pos(1) + pos(3)/2);
            digit_mid_points(digit,:) = [x, y];
            digit_mid_points_img(x-5:x+5, y-5:y+5) = 1;
        end
    end
end

digit_mid_point_overlay = imoverlay(img_binary, digit_mid_points_img, 'blue');
imshow(digit_mid_point_overlay)

%% Combined overlay
combined = labeloverlay(img, digit_mid_points_img+2*center_points_img, 'ColorMap', [0,0,1; 1,0,0]);
imshow(combined)

%% Find closest pairs of all digit mid point and dot center points
cps = center_points;
sorted_dot_list = zeros(nb_dots,2);
for i = 1:nb_dots
    diff = repmat(digit_mid_points(i,:),length(cps),1) - cps;
    [~, idx] = min(vecnorm(diff'));
    sorted_dot_list(i,:) = cps(idx,:);
    cps(idx,:) = [];
end
sdl = round(sorted_dot_list);

%% Draw lines between consecutive points
% Create an empty image to draw lines on
line_image = zeros(size(img_binary));
for i = 1:nb_dots-1
    line_image = draw_line(line_image, sdl(i,1), sdl(i,2), sdl(i+1,1), sdl(i+1,2));
end

overlay = imoverlay(img_binary, line_image, 'black');
imshow(overlay)

%% Fill in lines
se = strel('disk', 2, 6);
dilated = imdilate(line_image, se);
overlay = imoverlay(img_binary, dilated, 'black');
imshow(overlay)

%% Function to draw line between two points
function img = draw_line(img, x1, y1, x2, y2)
    if abs(y2-y1) < abs(x2-x1)
        img = draw_line_helper(img, x1, y1, x2, y2);
    else
        % If line is steep, transpose to get a better line
        img = draw_line_helper(img', y1, x1, y2, x2)';
    end
end

% Draw line between (x1,y1) and (x2,y2)
function img = draw_line_helper(img, x1, y1, x2, y2)
    line = polyfit([x1,x2], [y1,y2], 2);
    x = min([x1, x2]):max([x1, x2]);
    y = round(polyval(line, x));    
    img(sub2ind(size(img), x', y'))=1;
end
