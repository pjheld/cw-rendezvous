clc; close all; clear;

% Call ODE
%[t,X] = rendezvous_sim();

% % Plotting
% figure();
% plot(t, X(:,1:3));
% xlim([0, 3000]);
% legend('x','y','z');
% title('Rendezvous');
% xlabel('Time (s)');
% ylabel('Position (km)');

%[x0, ~, n, ~] = orbital_params();
%[A, ~] = cw_dynamics(n);
%validate(x0, n, A);

%animate_rendezvous(t, X)
%animate_rendezvous_cw(t,X)

 %plot_thrust call
 [x0, t_span, n] = orbital_params();
 [A, B] = cw_dynamics(n);
 K = lqr_controller(A, B);
 [t, X] = rendezvous_sim();
 plot_thrust(t, X, K);

monte_carlo_analysis();