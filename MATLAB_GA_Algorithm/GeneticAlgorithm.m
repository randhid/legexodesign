clc;
clear;
close all;


%% Problem Definition

problem.CostFunction = @(x) MinOne(x);      % Cost function
problem.nVar = 20;                          % number of changing variables


%% GA Parameters

params.MaxIt = 2000;                         % Maximum number of GA iterations
params.nPop = 20;                           % Population size
params.c_percentage = 1;                    % Number of offspring compare to Population size
params.mutation_rate = 0.1;                 % Mutation rate

%% Run GA

result = GA(problem, params);


%% Result

figure;
plot(result.BestCost_List, 'LineWidth', 2);
title('Convergent plot');
xlabel('Iteration');
ylabel('Best Cost');
grid on;