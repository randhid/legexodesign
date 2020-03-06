function [output] = PSO(problem, params)
%PSO Summary of this function goes here


    %% Problem Definition

    CostFunction = problem.CostFunction; % Cost Function

    nVar = problem.nVar;           % number of unkown (Decision) Variables

    VarSize = [1 nVar]; % Matrix Size of Desicion Variables

    VarMin = problem.VarMin;       % Lower Bound of Decision Variables
    VarMax = problem.VarMax;        % Upper Bound of Decision Variables


    %% Parameters of PSO

    MaxIteration = params.MaxIt;         % Maximum Number of Iterations

    nParticles = params.nPop;            % Population Size (Swarm Size)

    w = params.w;                      % Inertia Coefficient
    wdamp = params.wdamp;               % Damping Ratio of Inertia Coefficient
    c1 = params.c1;                     % Personal Acceleration Coefficient
    c2 = params.c2;                     % Social Acceleration Coefficient

    % The Flag for showing iteration information
    ShowIterationInfo = params.ShowIterInfo;
    
    % Limit the velocity
    MaxVelocity = 0.2*(VarMax - VarMin);
    MinVelocity = -MaxVelocity;
    

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

            
            % Apply velocity Limits
            particles(i).Velocity = max(particles(i).Velocity, MinVelocity);
            particles(i).Velocity = min(particles(i).Velocity, MaxVelocity);
            
            
            % Update the position based on velocity
            particles(i).Position = particles(i).Position + particles(i).Velocity;
            
            
            % Apply Lower and Upper Bound Limits
            particles(i).Position = max(particles(i).Position, VarMin);
            particles(i).Position = min(particles(i).Position, VarMax);
            

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

        if ShowIterationInfo
            % Display Iteration Information
            disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts(it))]);
        end
        
        % Damping Inertia Coefficient
        w = w * wdamp;

    end

    
    %% return values
    output.last_it_pop = particles;
    output.GlobalBest = GlobalBest;
    output.BestCosts_list = BestCosts;
    
    
end

