f = [1, 2, 2, 6, 8, 9, 8];

num_points = 1000;
lx = linspace(0, 10, num_points);

Fg = zeros(num_points);

for xi = 1:num_points
    for i = 1:length(f)
        Fg(xi) = Fg(xi) + g(lx(xi) - i) * f(i);        
    end
end

plot(lx, Fg)

%% One Dirac-function at a time:
figure
hold on
ff = diag(f);
for j = 1:7
    Fg = zeros(num_points);
    for xi = 1:num_points
        for i = 1:length(ff(1,:))
            Fg(xi) = Fg(xi) + g(lx(xi) - i) * ff(j,i);  
        end
    end
    plot(lx,Fg)
end