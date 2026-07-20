function [x0,t_span,n,a] = orbital_params()

% Earth Parameters
mu = 398600.4418;    % gravitational parameter (km^3/s^2)
Re = 6371;           % Earth radius (km)
alt = 400;           % orbital altitude (km)
a = Re + alt;        % orbital radius (km)
n = sqrt(mu/a^3);    % mean motion (rad/s)

% Chaser Initial State [x,y,z,vx,vy,vz] (km, km/s)
x0 = [-1; -5; 0; 0; 0; 0];

% Simulation Time
t_span = [0, 5 * 2*pi/n]; % 5 orbital periods

end