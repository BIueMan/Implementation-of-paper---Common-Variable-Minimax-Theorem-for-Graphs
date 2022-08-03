function D = find_D(A)
    k = size(A,1);
    epsilon = 10^-6;
    
    Q_1 = eye(k);
    Q_2 = diag(A* (Q_1^-1) *ones(k,1));
    for ii = 1:1000
        Q_1 = diag(A* (Q_2^-1) *ones(k,1));
        Q_2 = diag(A* (Q_1^-1) *ones(k,1));
        D = Q_2*Q_1;
        
        loss = sum(abs(D^-0.5 * A * D^-0.5 * ones(k,1) - ones(k,1)));
        if loss < epsilon
            break
        end
    end
    % return D
end