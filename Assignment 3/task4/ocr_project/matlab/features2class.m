function y = features2class(x, classification_data)
    %y = classify(x, classification_data);
    
    [m,n] = size(classification_data);
    X = zeros(m, 8);
    Y = zeros(m, 1);
    for i = 1:m
        X(i, :) = classification_data{i, 1};
        Y(i) = classification_data{i, 2};
    end
    model = fitcknn(X, Y, 'NumNeighbors', 1);
    y = predict(model, x');
    
   
end