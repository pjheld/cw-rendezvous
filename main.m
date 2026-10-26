clc; close all; clear;



[x0, ~, n, ~] = orbital_params();
[A,~] = cw_dynamics(n);
validate(x0,n,A);



