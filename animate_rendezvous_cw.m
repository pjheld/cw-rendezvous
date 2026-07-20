% Inputs: X: full state history, t: time vector (uneven)

function [] = animate_rendezvous_cw(t, X)

% Trim to capture point using relative distance
capture_radius = 0.01; % km
rel_dist = vecnorm(X(:,1:3), 2, 2);
capture_idx = find(rel_dist <= capture_radius, 1, 'first');
if isempty(capture_idx)
    capture_idx = length(t);
end
t = t(1:capture_idx);
X = X(1:capture_idx,:);

n_frames = 300;
t_uniform = linspace(t(1), t(end), n_frames);
X_u = interp1(t, X(:,1:3), t_uniform);

figure;
hold on; grid on; axis equal;
xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');
title('Rendezvous Animation (CW Frame)');

chaserTrail = plot3(NaN, NaN, NaN, 'b-', 'LineWidth', 1.5);
chaserPt = plot3(NaN, NaN, NaN, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
targetPt = plot3(0, 0, 0, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
legend([chaserPt, targetPt], {'Chaser', 'Target'});

span = 8; % km, half-width of the viewing window
xlim([-span, span]); ylim([-span, span]); zlim([-span, span]);

for i = 1:n_frames
    set(chaserTrail, 'XData', X_u(1:i,1), 'YData', X_u(1:i,2), 'ZData', X_u(1:i,3));
    set(chaserPt, 'XData', X_u(i,1), 'YData', X_u(i,2), 'ZData', X_u(i,3));
    drawnow;
    pause(0.03);
end

title('Rendezvous Complete — Target Captured');
end