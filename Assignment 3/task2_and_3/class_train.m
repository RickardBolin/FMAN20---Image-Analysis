function classification_data = class_train(X, Y)
[~, c] = size(X);
classification_data = cell(c, 2);
for i = 1:c
    classification_data{i, 1} = X(:,i);
    classification_data{i, 2} = Y(i);
end
end

