% Builds CW dynamics matrices A and B given mean motion n

function [A,B] = cw_dynamics(n)

A = [0,     0,    0,    1,    0,    0;
     0,     0,    0,    0,    1,    0;
     0,     0,    0,    0,    0,    1;
     3*n^2, 0,    0,    0,   2*n,   0;
     0,     0,    0,   -2*n,  0,    0;
     0,     0,   -n^2,  0,    0,    0];

B = [0, 0, 0;
     0, 0, 0;
     0, 0, 0;
     1, 0, 0;
     0, 1, 0;
     0, 0, 1];

end