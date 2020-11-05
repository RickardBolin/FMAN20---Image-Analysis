a = [0, -2 ,1; 2, 1, 1; -4, -3, 1];
b = [-8, -2, 1; 1, 3, 1; 5, 2, 1];

F = [2, 2, 6; 3, 3, 9; -7, -14, -6];

corresp = zeros(3);

for i = 1:3
    for j = 1:3
        corresp(i,j) = b(j,:)*F*a(i,:)';
    end
end

corresp
% a1 <-> b1, a3 <-> b3