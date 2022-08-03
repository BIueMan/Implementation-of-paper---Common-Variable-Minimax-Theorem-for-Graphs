function A = k_nn(points, k)
    A = zeros(size(points,1), size(points,1));
    
    % for every point, find k-nn
    for jj = 1:size(points,1)
        x_j = points(jj,:);
        dist = sum((points - x_j).^2, 2).^0.5;
        [B,I] = sort(dist);
        for ii = 1:k+1
            A(jj, I(ii)) = 1;
            A(I(ii), jj) = 1;
        end
    end
end