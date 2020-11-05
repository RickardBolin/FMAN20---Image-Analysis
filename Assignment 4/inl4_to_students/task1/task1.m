%% Preprocess the image
honeycomb = imread('task1/honeycomb.jpg');
honeycomb = imrotate(honeycomb, -1);
binary_honeycomb = imbinarize(rgb2gray(honeycomb));

se = strel('disk',17, 6);
eroded = imerode(binary_honeycomb, se);
se = strel('disk',5, 6);
dilated = imdilate(eroded, se);
no_filled = binary_honeycomb - dilated;
binary_honeycomb = no_filled;
imshow(binary_honeycomb)

%% Build hexagon shaped filter:
xCenter = 37;
yCenter = 41;
numSides = 6;
theta = linspace(0, 2*pi, numSides + 1);
theta = theta - pi/6;
r1 = 43;
r2 = 40;
x1 = r1 * cos(theta) + xCenter;
y1 = r1 * sin(theta) + yCenter;
x2 = r2 * cos(theta) + xCenter;
y2 = r2 * sin(theta) + yCenter;
hex_filter1 = poly2mask(x1, y1, 82, 74);
hex_filter2 = poly2mask(x2, y2, 82, 74);
hex_filter = hex_filter1 - hex_filter2;
imshow(hex_filter)
%% "Convolve" the filter with the image
[rows, cols] = size(hex_filter);
[M,N] = size(binary_honeycomb);
segmented_image = zeros(M,N);
segments = {};
% Create area that is the "interior of a cell" so we can see what cells
% we've already processed
interior = bwlabel(abs(hex_filter-1));
interior = (interior == mode(interior, 'all'))*2;

i = 1;
while i < M-rows
    j = 1;
    while j < N-cols
        % If the filter matches more than 75 percent of its white pixels
        % with the binary honeycomb, continue
        if sum(sum(hex_filter.*binary_honeycomb(i:i+rows-1, j:j+cols-1)))/...
            sum(sum(hex_filter)) > 0.75
            % If there are no '2':s inside the hexagon, ie the cell is not
            % already segmented, continue
            if max(max((segmented_image(i+20:i+rows-20, j+20:j+cols-20)))) < 2
                % Make sure we dont add the same cell in the future.
                segmented_image(i:i+rows-1, j:j+cols-1) = segmented_image(i:i+rows-1, j:j+cols-1) + interior;
                % Add segment to segments list
                segments{end+1} = honeycomb(i:i+rows-1, j:j+cols-1);
            end
        end
        j = j+1;
    end
    i = i+1;
end
imshow(segmented_image)
%% Show the interior of the segmented cells over the original image
overlay = imoverlay(honeycomb, segmented_image, 'red');
imshow(overlay)
%% Slideshow of the first 100 segmented cells
for i = 1:100
    imshow(segments{i})
    pause(1)
end
