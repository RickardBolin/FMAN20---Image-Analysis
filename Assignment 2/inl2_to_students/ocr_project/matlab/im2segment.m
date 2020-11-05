function [S] = im2segment(im)

nrofsegments = 5;
m = size(im,1);
n = size(im,2);
% Histogram equalization and binarization with threshold 0.85
bw = (histeq(im/255, 16) > 0.85);
% Give each distinct 4-neighbour area a unique label
[L, N] = bwlabel(bw, 4);

% If more than 5 labels found, keep the five largest ones
if N > 5
    new_L = zeros(m,n);
    for i = 1:nrofsegments + 1
        % Count the most common number in L
        m = mode(L, 'all');
        new_L = new_L + m*(L==m);
        % Set all of the already handled numbers to NaN
        L(L==m) = NaN ;
    end
    L = new_L;
end
% Binarize and label again to get label values 1:5 
%(can probably be done in a better way...)
[L, ~] = bwlabel(L>0, 4);


S = cell(1, nrofsegments);
% Place binary images of each label into 5 different cells.
for kk = 1:nrofsegments
    S{kk} = (L==kk);
    
    % Remove all pixels with one one neighbour (remove sharp edges)
    [r, c] = size(L);
    L_ = S{kk};
    for i = 2:r-1
        for j = 2:c-1
            if L_(i-1,j) + L_(i,j-1) + L_(i+1,j) + L_(i,j+1) < 2
                S{kk}(i,j) = 0;
            end
        end
    end
    
end

