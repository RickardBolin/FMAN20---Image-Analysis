function [u_p, r] = projection(u, bases)

% Check that the bases are orthogonal and normalize
for i = 1:length(bases)
    for j = 1:length(bases)
        d_p = dot_prod(bases{i}, bases{j});
        if i ~= j
            if (abs(d_p) > 1e-6)
                error("Bases not orthogonal!")
            end
        else
            % Normalize bases
            bases{i} = bases{i}/d_p;
        end
    end
end

% Calculate projection
u_p = zeros(size(u));
for i = 1:length(bases)
    u_p = u_p + dot_prod(u, bases{i})*bases{i};
end

% Calculate error
r = norm(u - u_p, 'fro');
end

% Function to calculate the dot product of two matrices
function dot_p = dot_prod(u1, u2)
    dot_p = sum(sum(u1.*u2));
end

