function output = GA(problem, params)

    %% Problem definition
    CostFunction = problem.CostFunction;        % Cost function
    nVar = problem.nVar;                        % number of changing variables
    VarSize = [1, nVar];                        % size of variable matrix
    VarMin = problem.VarMin;                    % lower bound
    VarMax = problem.VarMax;                    % upper bound
    FindMin = problem.FindMin;                  % find min flag
    
    
    %% GA Parameters
    MaxIt = params.MaxIt;                       % Maximum number of GA iterations
    Parent_PopSize = params.nPop;               % Parent Population Pool size
    beta = params.beta;                         % Parent score coefficient (<0 for find the minimum, >0 for find the maximum)
    offspring_percentage = params.c_percentage;         % Number of offsprings as percentage of Population Pool size (default = 1)
    offspring_PopSize = round(offspring_percentage*Parent_PopSize/2)*2;        % Children population size (Even number: two parents for two offsprings)
    mutation_rate = params.mutation_rate;       % mutation rate of the genetic algorithm
    sigma = params.sigma;                       % standard deviation of the gaussian noise in the mutation
    
    ShowIterationInfo = params.ShowIterInfo;        % The Flag for showing iteration information
                                                    
    
    %% Initialization
    
    % Template for Empty Individuals
    empty_individual.Position = [];             % Parameters list  (position is the parameters in this case)
    empty_individual.Cost = [];                 % Cost
    
    % Best Solution Ever Found
    GlobalBest.Position = [];
    
    if FindMin
        GlobalBest.Cost = inf;                  % inf for find the minimum, -inf for find the maximum
    else
        GlobalBest.Cost = -inf;
    end
    
    %% Generate the first parent population randomly
    
    % Create an empty popolation
    Parent_pop = repmat(empty_individual, Parent_PopSize, 1);    
    
    % Fill the population with random individual position (loop through the entire parent population)
    for i = 1:Parent_PopSize
        
        % generate random variable sets
        Parent_pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
        
        % calculate the cost
        Parent_pop(i).Cost = CostFunction(Parent_pop(i).Position);
        
        % Update the best variable, based on the cost
        if FindMin
            ParentCostUpdate = Parent_pop(i).Cost < GlobalBest.Cost;
        else
            ParentCostUpdate = Parent_pop(i).Cost > GlobalBest.Cost;
        end
            
        % record the best in the first iteration
        if ParentCostUpdate
            GlobalBest.Cost = Parent_pop(i).Cost;          % Or we can use (GlobalBest = pop(i);)
            GlobalBest.Position = Parent_pop(i).Position;
        end
    end
    
    % Record Best cost throughout the iterations
    BestCost_List = nan(MaxIt, 1);
    BestCandidate_List = [];
    
    
    %% Main loop (Mutate the existing offspring pool, or create a new offspring pool for mutation (two additonal offspring pool (one not mutated, one mutated)))
    for it = 1:MaxIt
        
        %% Selection Probabilities
        c = [Parent_pop.Cost]; % save all the parent cost in a list 
        c_avg = mean(c);       % calculate the average cost
        
        if c_avg ~= 0                       % prevent the divided by 0 error
            c = c/c_avg;                    % Normalize the cost list
        end
        score_list = exp(beta*c);           % calculate the parent's score based on their cost, the higher the score the greater change the parent will be pickes
        
        % Initialize Offspring pool (double column matrix, with even number of elements)
        offspring_pop = repmat(empty_individual, offspring_PopSize/2, 2);   % Create an empty children popolation, each row is two new offsprings
        
        %%% Crossover
        for k = 1:offspring_PopSize/2
            
            % Select two Parents based on the RouletteWheelSelection
            parent1 = Parent_pop(RouletteWheelSelection(score_list));
            parent2 = Parent_pop(RouletteWheelSelection(score_list));
            
            % Crossover (generate two offsprings by uniform crossover with gamma)
            [offspring_pop(k, 1).Position, offspring_pop(k, 2).Position] = UniformCrossover(parent1.Position, parent2.Position);
            
        end
        
        % Convert offspring pool to a single-column Matrix
        offspring_pop = offspring_pop(:);
        
        %% Mutation
        for l = 1:offspring_PopSize
            
            % Perform Mutation (mutate the offspring with gaussian noise and sigma as the standard deviation)
            offspring_pop(l).Position = Mutate(offspring_pop(l).Position, mutation_rate, sigma);
            
            % constrain the offspring ranges (after crossover and mutation), make sure the offspring doesn't go off limit
            offspring_pop(l).Position = max(offspring_pop(l).Position, VarMin);         % check the lower bound
            offspring_pop(l).Position = min(offspring_pop(l).Position, VarMax);         % check the upper bound
            
            % Evaluate the offspring
            offspring_pop(l).Cost = CostFunction(offspring_pop(l).Position);
            
            % Update the best variable, based on the cost
            if FindMin
                OffspringtCostUpdate = offspring_pop(l).Cost < GlobalBest.Cost;
            else
                OffspringtCostUpdate = offspring_pop(l).Cost > GlobalBest.Cost;
            end
            
            if OffspringtCostUpdate
                GlobalBest = offspring_pop(l);          
            end
        end
        
        
        %% Merge Populations
        Parent_pop = [Parent_pop; offspring_pop];
        
        %% Sort Population
        [~, sorted_Order] = sort([Parent_pop.Cost]);
        
        if FindMin
            Parent_pop = Parent_pop(sorted_Order);  
        else
            Parent_pop = Parent_pop(flip(sorted_Order));            % flip sorted_Order for find the maximum
        end
        
        %%% Remove Extra Individuals (only keep the top portion with parent population size)
        Parent_pop = Parent_pop(1: Parent_PopSize);
        
        %%% Record Best Cost of Iteration
        BestCost_List(it) = GlobalBest.Cost;
        BestCandidate_List = [BestCandidate_List; GlobalBest.Position];
        
        if ShowIterationInfo
            % Display Iteration Information
            if FindMin
                disp('(GA)Finding Minimum.....');
            else
                disp('(GA)Finding Maximum.....');
            end
            disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost_List(it))]);
            disp(['Best Solution = ' num2str(GlobalBest.Position)]);
            disp('******************************************************');
        end
        
    end
    
    
    %% Results
    output.last_iteration_pop = Parent_pop;                            % last parent population
    output.GlobalBest = GlobalBest;                     % final parameters and cost
    output.BestCosts_List = BestCost_List;              % the costs through all the iterations
    output.BestCandidate_List = BestCandidate_List;     % the best parameters through all the iterations
    
end














