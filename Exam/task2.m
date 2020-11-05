%% Load image
img = imread('examdata/blood.png');
figure
imshow(img)

%% Find sensitivity value that creates a good match for our background
T = adaptthresh(img,0.58,'ForegroundPolarity','dark');
imshow(T)

%% Binarize Image
img_binary = imbinarize(img, 'adaptive', 'Sensitivity',0.58, 'ForegroundPolarity','dark');
img_binary = abs(img_binary-1);
imshow(img_binary)

%% Dilate and erode
se = strel('disk', 3, 0);
eroded = imerode(img_binary, se);
se = strel('disk', 4, 0);
dilated = imdilate(eroded, se);
imshow(dilated)
% Count the number of cells
nb_cells = max(max(bwlabel(dilated)));

%% Overlay of dilated on the image
overlay = imoverlay(img, dilated, 'red');
imshow(overlay)

%% Plot the boundaries of each cell
[B,L] = bwboundaries(dilated,'noholes');
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
   boundary = B{k};
   plot(boundary(:,2), boundary(:,1), 'r', 'LineWidth', 2)
end

%% Alternative approach: Use 'imfindcircles' (Circular Hough Transform)
[centers, radii, metric] = imfindcircles(img,[15 80],'ObjectPolarity','dark', 'Sensitivity', 0.93);
imshow(img)
viscircles(centers, radii,'EdgeColor','b');
nb_cells_v2 = length(centers);
