clc;
clear;
close all;


%% Problem Definition

problem.CostFunction = @(x) Sphere(x);      % Cost function
problem.nVar = 6;                           % number of changing variables
problem.VarMin = [1 -1 1 1 -1 1];         % Upper bound
problem.VarMax = [10 10 10 10 10 10];             % Lower bound
problem.FindMin = true;                    % True for find minimum, false for find maximum


%% GA Parameters

params.MaxIt = 500;                         % Maximum number of GA iterations
params.nPop = 200;                           % Population size

params.beta = 1;                            % Parent score coefficient (<0 for find the minimum, >0 for find the maximum)
params.c_percentage = 1;                    % Number of offspring compare to Population size
params.mutation_rate = 0.001;               % Mutation rate
params.sigma = 0.1;                         % standard deviation of the gaussian noise in the mutation

params.ShowIterInfo = true;                 % Show interation

%% Run GA

result = GA(problem, params);


%% Result

figure;
plot(result.BestCosts_List, 'LineWidth', 2);
title('Convergent plot (GA)');
xlabel('Iteration');
ylabel('Best Cost');
grid on;



