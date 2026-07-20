function [] = plot_thrust(t,X,K)

% Trim to capture point using relative distance
capture_radius = 0.01; % km
rel_dist = vecnorm(X(:,1:3), 2, 2);
capture_idx = find(rel_dist <= capture_radius, 1, 'first');
if isempty(capture_idx)
    capture_idx = length(t);
end
t = t(1:capture_idx);
X = X(1:capture_idx,:);

% Thrust at every timestep
u_max = 3e-4; %km/s^2
U_raw = -X * K'; % unsaturated thrust
U = max(min(U_raw, u_max), -u_max); % apply saturation
thrust_mag = vecnorm(U, 2, 2);

% Total delta-V (area under thrust-magnitude curve)
delta_v = trapz(t, thrust_mag); % km/s

fprintf('=== THRUST / CONTROL EFFORT ===\n')
fprintf('Peak thrust magnitude: %.6e km/s^2\n', max(thrust_mag))
fprintf('Total delta-v: %.6e km/s\n', delta_v)

% Plotting
figure();
subplot(2,1,1)
plot(t/3600, U(:,1), t/3600, U(:,2), t/3600, U(:,3))
xlabel('Time (hr)'); ylabel('Thrust (km/s^2)')
title('Commanded thrust components')
legend('u_x', 'u_y', 'u_z')

subplot(2,1,2)
plot(t/3600, thrust_mag)
xlabel('Time (hr)'); ylabel('|Thrust| (km/s^2)')
title('Total thrust magnitude')

saveas(gcf, 'figures/thrust_profile.png');

end

