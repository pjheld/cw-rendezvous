function [] = monte_carlo_analysis()

[~, t_span, n] = orbital_params();
[A,B] = cw_dynamics(n);
K = lqr_controller(A,B);
u_max = 3e-4; % km/s^2
rng(1); % fixed seed

num_trials = 300;

x0_all = zeros(num_trials,1);
y0_all = zeros(num_trials,1);
delta_v_all = zeros(num_trials,1);
final_error_all = zeros(num_trials,1);
captured_all = zeros(num_trials,1);

for i = 1:num_trials
x0_all(i) = -15 + (30)*rand();
y0_all(i) = -50 + (100)*rand();
x0_trial = [x0_all(i); y0_all(i); 0; 0; 0; 0];

[t,X] = rendezvous_sim(x0_trial);

U_raw = -X * K'; 
U = max(min(U_raw, u_max), -u_max);
thrust_mag = vecnorm(U, 2, 2);

delta_v_all(i) = trapz(t, thrust_mag);
final_error_all(i) = norm(X(end, 1:3));
captured_all(i) = final_error_all(i) < 0.01; 
end
starting_distance_all = sqrt(x0_all.^2 + y0_all.^2);


fprintf('=== MONTE CARLO RESULTS (%d trials) ===\n', num_trials)
fprintf('Capture rate: %.1f%%\n', 100*mean(captured_all))
fprintf('Delta-v: mean %.4e km/s, min %.4e km/s, max %.4e km/s\n', ...
    mean(delta_v_all), min(delta_v_all), max(delta_v_all))
fprintf('Final error: mean %.4e km, max %.4e km\n', ...
    mean(final_error_all), max(final_error_all))

% Plotting
figure('Position', [100 100 700 450]);
histogram(delta_v_all*1000, 20)
xlabel('Delta-v (m/s)')
ylabel('Frequency')
title('Delta-v Distribution (300 trials)')
grid on
saveas(gcf, 'figures/delta_v_histogram.png');

figure('Position', [100 100 700 450]);
scatter(starting_distance_all, delta_v_all*1000, 20, 'filled')
xlabel('Starting Distance (km)')
ylabel('Delta-v (m/s)')
title('Delta-v vs. Starting Distance')
grid on
saveas(gcf, 'figures/delta_v_vs_distance.png');

end