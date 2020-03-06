clc;
clear;
close all;

%% Problem Definition

CostFunction = @(x) Sphere(x); % Cost Function

nVar = 5;           % number of unkown (Decision) Variables

VarSize = [1 nVar]; % Matrix Size of Desicion Variables

VarMin = -10;       % Lower Bound of Decision Variables
VarMax = 10;        % Upper Bound of Decision Variables


%% Parameters of PSO

MaxIteration = 1000;         % Maximum Number of Iterations

nParticles = 50;            % Population Size (Swarm Size)

w = 1;                      % Inertia Coefficient
wdamp = 0.99;               % Damping Ratio of Inertia Coefficient
c1 = 2;                     % Personal Acceleration Coefficient
c2 = 2;                     % Social Acceleration Coefficient


%% Initialization

% The Particle Template
empty_particle.Position = [];
empty_particle.Velocity = [];
empty_particle.Cost = [];
empty_particle.Best.Position = [];
empty_particle.Best.Cost = [];


% Initialize Global Best (inf for minimum problem, -inf for maximum problem)
GlobalBest.Cost = inf;


% Create Population Array
particles = repmat(empty_particle, nParticles, 1);

% Initialize Popolation members
for i = 1:nParticles
    
    % Generate Random Solution
    particles(i).Position = unifrnd(VarMin, VarMax, VarSize);
    
    % Initialize Velocity
    particles(i).Velocity = zeros(VarSize);
    
    % Evalution
    particles(i).Cost = CostFunction(particles(i).Position);
    
    % Update the Personal Best
    particles(i).Best.Position = particles(i).Position;
    particles(i).Best.Cost = particles(i).Cost;
    
    
    % Update Global Best
    if particles(i).Best.Cost < GlobalBest.Cost
        GlobalBest.Cost = particles(i).Best.Cost;
        GlobalBest.Position = particles(i).Best.Position;
    end
end

% Array to Hold Best Value 
BestCosts = zeros(MaxIteration, 1);


%% Main Loop of PSO

for it = 1:MaxIteration
    
    for i=1:nParticles
        
        % Calculate the velocity
        particles(i).Velocity = w*particles(i).Velocity ...
            + c1*rand(VarSize).*(particles(i).Best.Position - particles(i).Position) ...
            + c2*rand(VarSize).*(GlobalBest.Position - particles(i).Position);
        
        % Update the position based on velocity
        particles(i).Position = particles(i).Position + particles(i).Velocity;
        
        % Calculate the cost of new location
        particles(i).Cost = CostFunction(particles(i).Position);
        
        % Update the personal best
        if particles(i).Cost < particles(i).Best.Cost
            
            particles(i).Best.Position = particles(i).Position;
            particles(i).Best.Cost = particles(i).Cost;
            
            % Update Global Best
            if particles(i).Best.Cost < GlobalBest.Cost
                GlobalBest.Cost = particles(i).Best.Cost;
                GlobalBest.Position = particles(i).Best.Position;
            end
        end
    end
    
    % Store the best cost value
    BestCosts(it) = GlobalBest.Cost;
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
    
    % Damping Inertia Coefficient
    w = w * wdamp;
    
end



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















