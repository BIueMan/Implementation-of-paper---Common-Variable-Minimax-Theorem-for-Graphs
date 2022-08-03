function p = rotate_points(points, eta)
    p = zeros(size(points));
    for ii = 1:size(points,1)
        r = sum(points(ii,:).^2, 2) .^ 0.5;
        phi = atan(points(ii,2) / points(ii,1));
        p(ii,:) = [r*cos(phi + eta(ii)), r*sin(phi + eta(ii))];
    end
end