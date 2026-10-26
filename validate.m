% Validates numerical CW propagator against analytical solution

function [] = validate(x0, n, A)

% Time vector
t_span = [0, 5 * 2 * pi/n];
t = linspace(t_span(1), t_span(2), 1000);

% Numerical solution (no thrust: xdot = A*x)
[t, X_num] = ode45(@(t, x) A*x, t, x0, odeset('RelTol', 1e-9, 'AbsTol', 1e-12));

% Analytical solution
X_ana = cw_analytical(x0, t, n);

% Position error (km)
pos_error = vecnorm(X_num(:,1:3)' - X_ana(1:3,:));

% Jacobi constant (CW energy-like quantity)
% Computed along numerical solution
C = zeros(1,length(t));
for i = 1:length(t)
    xi  = X_num(i,1);
    yi  = X_num(i,2);
    zi  = X_num(i,3);
    dxi = X_num(i,4);
    dyi = X_num(i,5);
    dzi = X_num(i,6);
    C(i) = 3*n^2*xi^2 - n^2*zi^2 - (dxi^2 + dyi^2 + dzi^2);
end

C_drift = (max(C) - min(C)) / abs(C(1));

% Print Validation results
fprintf('=== VALIDATION RESULTS ===\n')
fprintf('Max position error vs analytical: %.6e km\n', max(pos_error))
fprintf('Mean position error vs analytical: %.6e km\n', mean(pos_error))
fprintf('Jacobi constant initial value: %.6e\n', C(1))
fprintf('Jacobi constant absolute drift: %.6e km^2/s^2\n', max(C) - min(C))
fprintf('Jacobi constant relative drift: %.3e %%\n', 100*C_drift)

% Plotting
figure();

subplot(3,1,1)
plot(t/3600, X_ana(1,:), 'b', t/3600, X_num(:,1)', 'r--')
xlabel('Time (hr)'); ylabel('x (km)')
title('Numerical vs Analytical — Radial')
legend('Analytical', 'Numerical')

subplot(3,1,2)
plot(t/3600, X_ana(2,:), 'b', t/3600, X_num(:,2)', 'r--')
xlabel('Time (hr)'); ylabel('y (km)')
title('Numerical vs Analytical — Along-track')
legend('Analytical', 'Numerical')

subplot(3,1,3)
plot(t/3600, pos_error)
xlabel('Time (hr)'); ylabel('Position error (km)')
title('Position error vs analytical solution')

figure();
plot(t/3600, C)
xlabel('Time (hr)'); ylabel('Jacobi constant')
title('Jacobi constant conservation')



end