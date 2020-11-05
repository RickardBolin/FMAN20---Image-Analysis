function gx = g(x)

if abs(x) <= 1
    gx = abs(x)^3 - 2 * abs(x)^2 + 1;
    
elseif abs(x) > 2 
    gx = 0;
    
else
    gx = -abs(x)^3 + 5 * abs(x)^2 - 8 * abs(x) + 4;
end

% Linear interpolation with triangle function:
%gx = 0;
%if abs(x) < 1
%    gx = 1 - abs(x);
end
