close all
clear

%% create data
seed = 1234;
rng(seed);

n = 500;
           
%% create data
r = rand(n,1);
phi = 2*pi*rand(n,1);
eta = pi*rand(n,1);
X1 = [r.*sin(phi).*cos(eta), r.*sin(phi).*sin(eta), r.*cos(phi)];

eta = 2*pi * rand(n,1);
phi = 2*pi * rand(n,1);
X2 = X1;
X2(:,[1,2]) = rotate_points(X1(:,[1,2]), eta);
X3 = X1;
X3(:,[1,3]) = rotate_points(X1(:,[1,3]), phi);

k = 6;
A1 = k_nn(X1, k);
A2 = k_nn(X2, k);
A3 = k_nn(X3, k);

D1 = find_D(A1);
D2 = find_D(A2);
D3 = find_D(A3);

L1 = eye(size(A1,1)) - D1^-0.5 * A1 * D1^-0.5;
L2 = eye(size(A2,1)) - D2^-0.5 * A2 * D2^-0.5;
L3 = eye(size(A3,1)) - D3^-0.5 * A3 * D3^-0.5;

%% plot 4
figure(4)
title('figure 1')
subplot(1,3,1)
title('G_1')
plot_2(X1, A1)
subplot(1,3,2)
title('G_2')
plot_2(X2, A2)
subplot(1,3,3)
title('G_3')
plot_2(X3, A3)

%% build Lt
[vector,value] = eig(L1);
value = value * ones(size(value,1),1);
psi_L11 = vector(:,2);
lambda1_1 = value(2);

[vector,value] = eig(L2);
value = value * ones(size(value,1),1);
psi_L21 = vector(:,2);
lambda2_1 = value(2);

[vector,value] = eig(L3);
value = value * ones(size(value,1),1);
psi_L31 = vector(:,2);
lambda3_1 = value(2);

global Lt_func
Lt_func = @(t1, t2) t1*L1/lambda1_1 + t2*L2/lambda2_1 + (1-t1-t2)*L3/lambda3_1;
lambda1_Lt = ones(101,101);
ii = 1;
for t1 = 0:1/(size(lambda1_Lt,2)-1):1
    jj = 1;
    for t2 = 0:1/(size(lambda1_Lt,2)-1):1
        if t1+t2 > 1
            continue
        end
        
        [vector,value] = eig(Lt_func(t1, t2));
        value = value * ones(size(value,1),1);
        lambda1_Lt(ii, jj) = value(2);
        jj = jj + 1;
    end
    ii = ii + 1;
end

% [M,I] = max(lambda1_Lt(:));
% index = [I - 101*(ceil(I/101)-1), ceil(I/101)];
% t_1_opt = index/size(lambda1_Lt,2);
% t_opt = [t_1_opt(1), t_1_opt(2), 1-t_1_opt(1)-t_1_opt(2)]

min_t = fminsearchbnd(@loss_func, [0.25,0.25], [0,0],[1,1]);
t_opt = [min_t(1), min_t(2), 1-min_t(1)-min_t(2)]

%% plot 5
figure(5)
hold on
title('figure 5')
X = repmat(0:1/(size(lambda1_Lt,2)-1):1, size(lambda1_Lt,2), 1);
Y = X.';
s = surf(X, Y, lambda1_Lt.');
s.EdgeColor = 'none';
shading interp
plot3(t_opt(1), t_opt(2), -loss_func(min_t), 'ko')
view(0,90);
xlabel('t_1')
ylabel('t_2')
hold off

map = [0 0 0.3
        0 0 0.3
        0 0 0.3
        0 0 0.3
        0 0 0.3
        0 0 0.3
        0 0 0.3
        0 0.3 0.4
        0 0.5 0.5
        0 0.6 0.6
        0 0.6 0.8
        0 0.7 0.8
        0 0.7 0.9
        0 0.7 1.0
        0 0.8 1.0
        0 0.9 1.0];

colormap(map)

%% plot 6
Lt = Lt_func(t_opt(1), t_opt(2));
% self vector of lambda_1
[vector,value] = eig(Lt);
value = value * ones(size(value,1),1);
psi_Lt1 = vector(:,2);
% get max(S_L1,S_L2)
S_L1 = 1/lambda1_1 * psi_Lt1.'*L1*psi_Lt1;
S_L2 = 1/lambda2_1 * psi_Lt1.'*L2*psi_Lt1;
S_L3 = 1/lambda3_1 * psi_Lt1.'*L3*psi_Lt1;
loss = abs(max([S_L1, S_L2, S_L3]) - value(2))

% sort point by the distance from the 0,0
r = sum(X1.^2, 2) .^ 0.5;
[V,I] = sort(r);

figure(6)
hold on
subplot(1,4,1)
plot(r(I), psi_Lt1(I))
xlabel('r')
ylabel('\psi_1(L_{t*})')

subplot(1,4,2)
plot(r(I), psi_L11(I))
xlabel('r')
ylabel('\psi_1(L_1)')

subplot(1,4,3)
plot(r(I), psi_L21(I))
xlabel('r')
ylabel('\psi_1(L_2)')

subplot(1,4,4)
plot(r(I), psi_L31(I))
xlabel('r')
ylabel('\psi_1(L_3)')

hold off

function lambda1_Lt = loss_func(t)
    global Lt_func;
    t1 = t(1);
    t2 = t(2);
    [~,value] = eig(Lt_func(t1, t2));
    value = value * ones(size(value,1),1);
    lambda1_Lt = -value(2);
end

function plot_2(points, A)
    s = size(A,1);
    
    hold on
    %scatter3(points(:,1), points(:,2), points(:,3), 'k', 'filled')
    
    for ii = 1:s
        for jj = 1:ii
            if A(ii,jj) == 1
                x = [points(ii,1),points(jj,1)];
                y = [points(ii,2),points(jj,2)];
                z = [points(ii,3),points(jj,3)];
                plot3(x,y,z,'k')
            end
        end
    end
    
    r = sqrt(3^0.5);
    xlim([-r r])
    ylim([-r r])
    zlim([-r r])
    grid on
    view(30,30)
    
    hold off
end