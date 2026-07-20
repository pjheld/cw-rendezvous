function [] = animate_rendezvous(t, X)
[r_target, r_chaser_eci] = cw_to_eci(t, X);

% Trim to capture point using relative distance (CW frame)
capture_radius = 0.01; % km
rel_dist = vecnorm(X(:,1:3), 2, 2);
capture_idx = find(rel_dist <= capture_radius, 1, 'first');
if isempty(capture_idx)
    capture_idx = length(t);
end
t = t(1:capture_idx);
r_target = r_target(1:capture_idx,:);
r_chaser_eci = r_chaser_eci(1:capture_idx,:);

n_frames = 300;
t_uniform = linspace(t(1), t(end), n_frames);
r_target_u = interp1(t, r_target, t_uniform);
r_chaser_u = interp1(t, r_chaser_eci, t_uniform);

figure;
hold on; grid on; axis equal;
xlabel('X (km)'); ylabel('Y (km)'); zlabel('Z (km)');
title('Rendezvous Animation (Zoomed, ECI Frame)');

chaserTrail = plot3(NaN, NaN, NaN, 'b-', 'LineWidth', 1.5);
targetTrail = plot3(NaN, NaN, NaN, 'r--', 'LineWidth', 1.5);
chaserPt = plot3(NaN, NaN, NaN, 'bo', 'MarkerFaceColor', 'b', 'MarkerSize', 10);
targetPt = plot3(NaN, NaN, NaN, 'ro', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
legend([chaserPt, targetPt], {'Chaser', 'Target'});

span = 8; % km, half-width of the viewing window — tune to your initial offset
gif_filename = 'figures/rendezvous.gif';
frame_skip = 5; % capture every 5th frame

for i = 1:n_frames
    set(chaserTrail, 'XData', r_chaser_u(1:i,1), 'YData', r_chaser_u(1:i,2), 'ZData', r_chaser_u(1:i,3));
    set(targetTrail, 'XData', r_target_u(1:i,1), 'YData', r_target_u(1:i,2), 'ZData', r_target_u(1:i,3));
    set(chaserPt, 'XData', r_chaser_u(i,1), 'YData', r_chaser_u(i,2), 'ZData', r_chaser_u(i,3));
    set(targetPt, 'XData', r_target_u(i,1), 'YData', r_target_u(i,2), 'ZData', r_target_u(i,3));

    c = r_target_u(i,:); % recenter window on target's real ECI position
    xlim([c(1)-span, c(1)+span]);
    ylim([c(2)-span, c(2)+span]);
    zlim([c(3)-span, c(3)+span]);

    drawnow;
    pause(0.03);
if mod(i-1, frame_skip) == 0
    frame = getframe(gcf);
    img = frame2im(frame);
    [imind, cm] = rgb2ind(img, 256);
    if i == 1
        imwrite(imind, cm, gif_filename, 'gif', 'Loopcount', inf, 'DelayTime', 0.05);
    else
        imwrite(imind, cm, gif_filename, 'gif', 'WriteMode', 'append', 'DelayTime', 0.05);
    end
end

end

title('Rendezvous Complete — Target Captured');
end