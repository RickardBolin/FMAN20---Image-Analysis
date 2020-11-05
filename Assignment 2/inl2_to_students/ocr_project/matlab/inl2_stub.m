datadir = '../datasets/short1';

a = dir(datadir);

file = 'im1';

fnamebild = [datadir filesep file '.jpg'];
fnamefacit = [datadir filesep file '.txt'];

bild = imread(fnamebild);
fid = fopen(fnamefacit);
facit = fgetl(fid);
fclose(fid);

S = im2segment(double(bild));
for i = 1:5
    B = S{i};
    facit(i)
    x = segment2features(B);
end
