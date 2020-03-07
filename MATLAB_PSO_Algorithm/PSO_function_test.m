clc;
clear;
close all;

%% Problem Definition

problem.CostFunction = @(x) Sphere(x); % Cost Function

problem.nVar = 10;           % number of unkown (Decision) Variables

problem.VarMin = -10;       % Lower Bound of Decision Variables
problem.VarMax = 10;        % Upper Bound of Decision Variables


%% Parameters of PSO

Kappa = 1;
phi1 = 2.05;
phi2 = 2.05;
phi = phi1 + phi2;
chi = 2*Kappa/abs(2-phi-sqrt(phi^2-4*phi));


params.MaxIt = 1000;         % Maximum Number of Iterations

params.nPop = 50;            % Population Size (Swarm Size)

params.w = chi;                      % Inertia Coefficient
params.wdamp = 1;               % Damping Ratio of Inertia Coefficient
params.c1 = chi*phi1;                     % Personal Acceleration Coefficient
params.c2 = chi*phi2;                     % Social Acceleration Coefficient

params.ShowIterInfo = true;        % Show interation


%% Calling PSO

result = PSO(problem, params);

BestCosts = result.BestCosts_list;
BestSolution = result.GlobalBest;


%% Results

figure;
plot(BestCosts, 'LineWidth', 2);
title('Convergent plot');
xlabel('Iteration');
ylabel('Best Cost');
grid on;

figure;
semilogy(BestCosts, 'LineWidth', 2);
title('Convergent plot (Semilogy)');
xlabel('Iteration');
ylabel('Best Cost');
grid on;

