% Computes the analytical CW solution for the no-thrust case
% Inputs: x0 (initial state), t (time vector), n (mean motion)
% Output: x (6xN state history)

function [x] = cw_analytical(x0,t,n)

% Unpack initial conditions
x0_ = x0(1);
y0_ = x0(2);
z0_ = x0(3);
dx0 = x0(4);
dy0 = x0(5);
dz0 = x0(6);

x = zeros(6, length(t));

for i = 1:length(t)
    ti = t(i);

    % Position
    x(1,i) = (4 - 3*cos(n*ti))*x0_ + sin(n*ti)*(dx0/n) + 2*(1 - cos(n*ti))*(dy0/n);
    x(2,i) = 6*(sin(n*ti) - n*ti)*x0_ + y0_ - 2*(1 - cos(n*ti))*(dx0/n) + (4*sin(n*ti) - 3*n*ti)*(dy0/n);
    x(3,i) = z0_*cos(n*ti) + (dz0/n)*sin(n*ti);

    % Velocity
    x(4,i) = 3*n*sin(n*ti)*x0_ + cos(n*ti)*dx0 + 2*sin(n*ti)*dy0;
    x(5,i) = 6*n*(cos(n*ti) - 1)*x0_ - 2*sin(n*ti)*dx0 + (4*cos(n*ti) - 3)*dy0;
    x(6,i) = -z0_*n*sin(n*ti) + dz0*cos(n*ti);

end

end