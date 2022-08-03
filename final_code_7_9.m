close all
clear

%% create data
seed = 1234;
rng(seed);

n = 250;
           
%% create data
r = rand(n,1);
phi = 2*pi*rand(n,1);
X1 = [r.*cos(phi), r.*sin(phi)];
f = @(x,y) [x, y.*(1-cos(pi.*x))];
g = @(x,y) [x.*(1-cos(pi.*y)), y];
X2 = f(X1(:,1), X1(:,2));
X3 = g(X1(:,1), X1(:,2));

k = 6;
A1 = k_nn(X1, k);
A2 = k_nn(X2, k);
A3 = k_nn(X3, k);

% plot 1
figure(7)
title('figure 1')
subplot(1,3,1)
title('G_1')
plot_1(X1, A1)
subplot(1,3,2)
title('G_2')
plot_1(X2, A2)
subplot(1,3,3)
title('G_2')
plot_1(X3, A3)

%% build Lt
D1 = find_D(A1);
D2 = find_D(A2);
D3 = find_D(A3);

L1 = eye(size(A1,1)) - D1^-0.5 * A1 * D1^-0.5;
L2 = eye(size(A2,1)) - D2^-0.5 * A2 * D2^-0.5;
L3 = eye(size(A3,1)) - D3^-0.5 * A3 * D3^-0.5;

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
lambda1_Lt = zeros(101,101);
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

%% plot 8
figure(8)
hold on
title('figure 8')
X = repmat(0:1/(size(lambda1_Lt,2)-1):1, size(lambda1_Lt,2), 1);
Y = X.';
s = surf(X, Y, lambda1_Lt.');
s.EdgeColor = 'none';
shading interp
plot3(t_opt(1), t_opt(2), -loss_func(t_opt(1:2)), 'ko')
view(0,90);
xlabel('t_1')
ylabel('t_2')
hold off

%% plot 9
Lt = Lt_func(t_opt(1), t_opt(2));
% self vector of lambda_1
[vector,value] = eig(Lt);
value = value * ones(size(value,1),1);
psi_Lt1 = vector(:,2);
psi_Lt = vector(:,2:4);
% get max(S_L1,S_L2)
S_L1 = 1/lambda1_1 * psi_Lt1.'*L1*psi_Lt1;
S_L2 = 1/lambda2_1 * psi_Lt1.'*L2*psi_Lt1;
S_L3 = 1/lambda3_1 * psi_Lt1.'*L3*psi_Lt1;
loss = abs(max([S_L1, S_L2, S_L3]) - value(2))

% sort point by the distance from the 0,0
% split point to quaters
quat_1 = X1(:,1) > 0 & X1(:,2) > 0; % '*'
quat_2 = X1(:,1) <= 0 & X1(:,2) > 0; % '+'
quat_3 = X1(:,1) <= 0 & X1(:,2) <= 0; % 'x'
quat_4 = X1(:,1) > 0 & X1(:,2) <= 0; % 'o'

figure(9)
title('The first three nontrivial eigenvectors of L_{t-opt}')
hold on
scatter3(psi_Lt(quat_1,1), psi_Lt(quat_1,2), psi_Lt(quat_1,3), '*')
scatter3(psi_Lt(quat_2,1), psi_Lt(quat_2,2), psi_Lt(quat_2,3), '+')
scatter3(psi_Lt(quat_3,1), psi_Lt(quat_3,2), psi_Lt(quat_3,3), 'x')
scatter3(psi_Lt(quat_4,1), psi_Lt(quat_4,2), psi_Lt(quat_4,3), 'o')
hold off
grid on
legend({'NE','NW','SW','SE'},'Location','southwest')
view(300,20)

function lambda1_Lt = loss_func(t)
    global Lt_func;
    t1 = t(1);
    t2 = t(2);
    [~,value] = eig(Lt_func(t1, t2));
    value = value * ones(size(value,1),1);
    lambda1_Lt = -value(2);
end

function plot_1(points, A)
    s = size(A,1);
    
    hold on
    r = sqrt(2);
    xlim([-r r])
    ylim([-r r])
    
    %scatter(points(:,1), points(:,2), 'k', 'filled')
    
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