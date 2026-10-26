clc; close all; clear;

% Single rendezvous example with animation
[t, X] = rendezvous_sim();
animate_rendezvous(t, X)
