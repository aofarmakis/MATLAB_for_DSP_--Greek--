% Define and create the Gamma distribution
pd = makedist('Gamma', 'a', 4, 'b', 1/4);

% Mean = a * b
% Variance = a * b^2

% Save the Gamma distribution to a .mat file
save('gamma_distribution.mat', 'pd');