function [r_target, r_chaser_eci] = cw_to_eci(t, X)

[~,~,n,a] = orbital_params();
r_target = a * [cos(n*t), sin(n*t), zeros(size(t))];
r_chaser_eci = zeros(length(t), 3);

for i = 1:length(t)
    x_hat = [cos(n*t(i)), sin(n*t(i)), 0]; 
    y_hat = [-sin(n*t(i)), cos(n*t(i)), 0];
    z_hat = [0, 0, 1];
    R = [x_hat; y_hat; z_hat];
    r_chaser_eci(i,:) = (R' * X(i,1:3)')' + r_target(i,:); % Target -> Chaser + Earth -> Target = Earth -> Chaser
end

end