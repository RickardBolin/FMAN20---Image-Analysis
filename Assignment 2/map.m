ms = [0.4, 0.3, 0.5];
sigmas = [0.01, 0.05, 0.2];

dps = [0.4003, 0.3985, 0.3998, 0.3997, 0.4015, 0.3995, 0.3991; 
       0.2554, 0.3139, 0.2627, 0.3802, 0.3247, 0.3360, 0.2974; 
       0.5632, 0.7687, 0.0524, 0.7586, 0.4443, 0.5505, 0.6469];
   
argmaxs = zeros(size(dps));

for class = 1:3
    for testpoint = 1:7
        biggest = 0;
        max_idx = 0;
        for normal_idx = 1:3
            curr_val = normpdf(dps(class, testpoint), ms(normal_idx), sigmas(normal_idx)) / 3;
            if curr_val > biggest
                biggest = curr_val;
                max_idx = normal_idx;
            end
        end
        argmaxs(class, testpoint) = max_idx;
    end
end

true_classes = ones(3, 7);
true_classes(2, :) = true_classes(2, :) * 2;
true_classes(3, :) = true_classes(3, :) * 3;

incorrs = sum(sum(argmaxs ~= true_classes));
