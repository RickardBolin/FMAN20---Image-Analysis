function y = classify(x, classification_data)
min_norm = Inf;
y = 0;
for i = 1:length(classification_data)
    nrm = norm(x - classification_data{i, 1});
    if nrm < min_norm
        min_norm = nrm;
        y = classification_data{i, 2};
    end
end
end

