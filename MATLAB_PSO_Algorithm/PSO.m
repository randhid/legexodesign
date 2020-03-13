function [output] = PSO(problem, params)

    %% Problem Definition

    CostFunction = problem.CostFunction;        % Cost Function
    nVar = problem.nVar;                        % number of unkown (Decision) Variables
    VarSize = [1 nVar];                         % Matrix Size of Desicion Variables
    VarMin = problem.VarMin;                    % Lower Bound of Decision Variables
    VarMax = problem.VarMax;                    % Upper Bound of Decision Variables
    FindMin = problem.FindMin;                  % find min flag


    %% Parameters of PSO

    MaxIteration = params.MaxIt;         % Maximum Number of Iterations
    nParticles = params.nPop;            % Population Size (Swarm Size)
    w = params.w;                        % Inertia Coefficient
    wdamp = params.wdamp;                % Damping Ratio of Inertia Coefficient
    c1 = params.c1;                      % Personal Acceleration Coefficient
    c2 = params.c2;                      % Social Acceleration Coefficient

    % The Flag for showing iteration information
    ShowIterationInfo = params.ShowIterInfo;
    
    % Limit the velocity
    MaxVelocity = 0.1*(VarMax - VarMin);
    MinVelocity = -MaxVelocity;
    

    %% Initialization

    % The Particle Template
    empty_particle.Position = [];
    empty_particle.Velocity = [];
    empty_particle.Cost = [];
    empty_particle.Best.Position = [];
    empty_particle.Best.Cost = [];


    % Initialize Global Best (inf for minimum problem, -inf for maximum problem)
    if FindMin
        GlobalBest.Cost = inf;                  % inf for find the minimum, -inf for find the maximum
    else
        GlobalBest.Cost = -inf;
    end

    %% Generate the first parent population randomly
    
    % Create an empty popolation
    particles = repmat(empty_particle, nParticles, 1);

    % Fill the population with random individual position (loop through the entire particle population)
    for i = 1:nParticles

        % generate Random variable sets
        particles(i).Position = unifrnd(VarMin, VarMax, VarSize);

        % initialize Velocity with zeros
        particles(i).Velocity = zeros(VarSize);

        % calculate the cost
        particles(i).Cost = CostFunction(particles(i).Position);

        % save the initialization population as the current Personal Best
        particles(i).Best.Position = particles(i).Position;
        particles(i).Best.Cost = particles(i).Cost;


        % Update the global best variable, based on the cost
        if FindMin
            InitialGlobalUpdate = particles(i).Best.Cost < GlobalBest.Cost;
        else
            InitialGlobalUpdate = particles(i).Best.Cost > GlobalBest.Cost;
        end
        
        if InitialGlobalUpdate
            GlobalBest.Cost = particles(i).Best.Cost;
            GlobalBest.Position = particles(i).Best.Position;
        end
    end

    % Record Best cost of the iterations
    BestCosts_List = zeros(MaxIteration, 1);
    BestCandidate_List = [];
    

    %% Main Loop of PSO

    for it = 1:MaxIteration

        % loop through the entire particle population
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
            
            
            % Apply Lower and Upper Bound Limits for the parameters
            particles(i).Position = max(particles(i).Position, VarMin);
            particles(i).Position = min(particles(i).Position, VarMax);
            

            % Calculate the cost of new location
            particles(i).Cost = CostFunction(particles(i).Position);
            
            
            % Update the personal and Global best variable, based on the cost
            if FindMin
                PersonalUpdate = particles(i).Cost < particles(i).Best.Cost;
                MainGlobalUpdate = particles(i).Best.Cost < GlobalBest.Cost;
            else
                PersonalUpdate = particles(i).Cost > particles(i).Best.Cost;
                MainGlobalUpdate = particles(i).Best.Cost > GlobalBest.Cost;
            end
            
            
            % Update the personal best
            if PersonalUpdate

                particles(i).Best.Position = particles(i).Position;
                particles(i).Best.Cost = particles(i).Cost;

                % Update Global Best
                if MainGlobalUpdate
                    GlobalBest.Cost = particles(i).Best.Cost;
                    GlobalBest.Position = particles(i).Best.Position;
                end
            end
        end

        % Store the best cost value
        BestCosts_List(it) = GlobalBest.Cost;
        BestCandidate_List = [BestCandidate_List; GlobalBest.Position];

        if ShowIterationInfo
            % Display Iteration Information
            if FindMin
                disp('(PSO)Finding Minimum.....');
            else
                disp('(PSO)Finding Maximum.....');
            end
            disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCosts_List(it))]);
            disp(['Best Solution = ' num2str(GlobalBest.Position)]);
            disp('******************************************************');
        end
        
        % Damping Inertia Coefficient
        w = w * wdamp;

    end

    
    %% return values
    output.last_iteration_pop = particles;              % last particle population
    output.GlobalBest = GlobalBest;                     % final parameters and cost
    output.BestCosts_List = BestCosts_List;             % the costs through all the iterations
    output.BestCandidate_List = BestCandidate_List;     % the best parameters through all the iterations
    
end

