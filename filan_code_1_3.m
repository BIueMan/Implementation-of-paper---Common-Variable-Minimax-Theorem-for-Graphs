close all
clear

%% create data
seed = 1234;
rng(seed);

points_count = [2, 250];
           
%% create data
points = rand(points_count).' - 0.5;
eta = 2*pi * rand(points_count(2),1);
points_rotate = rotate_points(points, eta);

k = 6;
A1 = k_nn(points, k);
A2 = k_nn(points_rotate, k);

D1 = find_D(A1);
D2 = find_D(A2);

L1 = eye(size(A1,1)) - D1^-0.5 * A1 * D1^-0.5;
L2 = eye(size(A2,1)) - D2^-0.5 * A2 * D2^-0.5;

% plot 1
figure(1)
title('figure 1')
subplot(1,2,1)
title('G_1')
plot_1(points, A1)
subplot(1,2,2)
title('G_2')
plot_1(points_rotate, A2)

%% build Lt
[vector,value] = eig(L1);
value = value * ones(size(value,1),1);
psi_L11 = vector(:,2);
lambda1_1 = value(2);

[vector,value] = eig(L2);
value = value * ones(size(value,1),1);
psi_L21 = vector(:,2);
lambda2_1 = value(2);

global Lt_func
Lt_func = @(t1) t1*L1/lambda1_1 + (1-t1)*L2/lambda2_1;
lambda1_Lt = zeros(1,1001);
ii = 1;
for t = 0:1/(size(lambda1_Lt,2)-1):1
    [~,value] = eig(Lt_func(t));
    value = value * ones(size(value,1),1);
    lambda1_Lt(ii) = value(2);
    ii = ii + 1;
end

% find minimus
min_t = fminbnd(@loss_func, 0, 1);
t_opt = [min_t, 1-min_t]

figure(2)
hold on
title('figure 2')
plot(0:1/(size(lambda1_Lt,2)-1):1, lambda1_Lt.', 'k')
plot(t_opt(1), -loss_func(t_opt(1)), 'x','MarkerSize', 30)
xlabel('t_1')
ylabel('\lambda_1(L_t)')
hold off

%% plot 3
Lt = Lt_func(t_opt(1));
% self vector of lambda_1
[vector,value] = eig(Lt);
value = value * ones(size(value,1),1);
psi_Lt1 = vector(:,2);
% get max(S_L1,S_L2)
S_L1 = 1/lambda1_1 * psi_Lt1.'*L1*psi_Lt1;
S_L2 = 1/lambda2_1 * psi_Lt1.'*L2*psi_Lt1;
loss = abs(max(S_L1, S_L2) - value(2))

% sort point by the distance from the 0,0
r = sum(points.^2, 2) .^ 0.5;
[V,I] = sort(r);

figure(3)
hold on
subplot(1,3,1)
plot(r(I), psi_Lt1(I))
xlabel('r')
ylabel('\psi_1(L_{t*})')

subplot(1,3,2)
plot(r(I), psi_L11(I))
xlabel('r')
ylabel('\psi_1(L_1)')

subplot(1,3,3)
plot(r(I), psi_L21(I))
xlabel('r')
ylabel('\psi_1(L_2)')

hold off

function lambda1_Lt = loss_func(t)
    global Lt_func;
    [~,value] = eig(Lt_func(t));
    value = value * ones(size(value,1),1);
    lambda1_Lt = -value(2);
end

function plot_1(points, A)
    s = size(A,1);
    
    hold on
    r = sqrt(2*0.5^2);
    xlim([-r r])
    ylim([-r r])
    
    scatter(points(:,1), points(:,2), 'k', 'filled')
    
    for ii = 1:s
        for jj = 1:ii
            if A(ii,jj) == 1
                x = [points(ii,1),points(jj,1)];
                y = [points(ii,2),points(jj,2)];
                plot(x, y, 'k')
            end
        end
    end
    hold off
end