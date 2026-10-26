% Designs LQR controller
% Inputs: A, B matrices
% Outputs: gain matrix K

function K = lqr_controller(A, B)

% State cost matrix 
Q = diag([1, 1, 1, 1, 1, 1]);

% Control cost matrix (penalize fuel use equally in all directions)
R = diag([1e8, 1e8, 1e8]);

% K = lqr(A, B, Q, R);
%[P, ~, ~] = care(A, B, Q, R);

% Hamiltonian
Rinv = inv(R);
H = [A, -B*Rinv*B'; -Q, -A'];
[V, D] = eig(H);
eigenvalues = diag(D);
neg_eigenvalues = real(eigenvalues) < 0;
V_stable = V(:,neg_eigenvalues);
V1 = V_stable(1:6, :);
V2 = V_stable(7:12,:);
P = V2/V1;


% Calculate Gain Matrix
K = real(Rinv * B' * P);

fprintf('=== LQR CONTROLLER ===\n')
fprintf('K matrix computed successfully\n')
fprintf('K =\n')
disp(K)

end