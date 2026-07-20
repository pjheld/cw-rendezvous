function [t, X] = rendezvous_sim(x0)

% Loading Parameters
if nargin < 1
    [x0, t_span, n] = orbital_params();
else
    [~, t_span, n] = orbital_params();
end
[A,B] = cw_dynamics(n);
K = lqr_controller(A, B);

u_max = 3e-4; %km/s^2

% ODE
options = odeset('RelTol',1e-9,'AbsTol',1e-12);
odefun = @(t,x) cw_controlled(t, x, A, B, K, u_max);
[t, X] = ode45(odefun, t_span, x0, options);

fprintf('=== RENDEZVOUS SIM ===\n')
fprintf('Simulaton complete\n')

end

function xdot = cw_controlled(t, x, A, B, K, u_max)
u_raw = -K*x;
u = saturate_thrust(u_raw, u_max);
xdot = A*x + B*u;
end

function u = saturate_thrust(u_raw, u_max)
u = max(min(u_raw, u_max), -u_max);
end