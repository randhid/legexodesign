clc;
clear;
close all;

%% Problem Definition

problem.CostFunction = @(x) Sphere(x);      % Cost Function
problem.nVar = 6;                           % number of unkown (Decision) Variables
problem.VarMin = [1 -1 1 -1 -1 1];               % Lower Bound of Decision Variables
problem.VarMax = [10 10 10 10 10 10];          % Upper Bound of Decision Variables
problem.FindMin = true;                     % True for find minimum, false for find maximum


%% PSO Parameters

% Suggestion for the PSO hyperparameters
Kappa = 1;
phi1 = 2.05;
phi2 = 2.05;
phi = phi1 + phi2;
chi = 2*Kappa/abs(2-phi-sqrt(phi^2-4*phi));

params.MaxIt = 500;         % Maximum Number of Iterations
params.nPop = 200;            % Population Size (Swarm Size)

params.w = chi;                      % Inertia Coefficient
params.wdamp = 1;               % Damping Ratio of Inertia Coefficient
params.c1 = chi*phi1;                     % Personal Acceleration Coefficient
params.c2 = chi*phi2;                     % Social Acceleration Coefficient

params.ShowIterInfo = true;        % Show interation


%% Run PSO

result = PSO(problem, params);


%% Results

figure;
plot(result.BestCosts_List, 'LineWidth', 2);
title('Convergent plot (PSO)');
xlabel('Iteration');
ylabel('Best Cost');
grid on;

