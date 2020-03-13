clc;
clear;
close all;


%% Problem Definition

problem.CostFunction = @(x) MinOne(x);      % Cost function
problem.nVar = 1000;                          % number of changing variables
problem.FindMin = true;                      % True for find minimum, false for find maximum


%% GA Parameters

params.MaxIt = 1000;                         % Maximum number of GA iterations
params.nPop = 50;                           % Population size

params.beta = 1;                            % Parent score coefficient (<0 for find the minimum, >0 for find the maximum)
params.c_percentage = 1;                    % Number of offspring compare to Population size
params.mutation_rate = 0.001;                 % Mutation rate

%% Run GA

result = GA(problem, params);


%% Result

figure;
plot(result.BestCost_List, 'LineWidth', 2);
title('Convergent plot');
xlabel('Iteration');
ylabel('Best Cost');
grid on;