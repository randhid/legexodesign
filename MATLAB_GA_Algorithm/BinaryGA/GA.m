function output = GA(problem, params)

    %% Problem definition
    CostFunction = problem.CostFunction;        % Cost function
    nVar = problem.nVar;                        % number of changing variables
    FindMin = problem.FindMin;                  % find min flag
    
    
    %% GA Parameters
    MaxIt = params.MaxIt;                       % Maximum number of GA iterations
    Parent_PopSize = params.nPop;                         % Population Pool size
    beta = params.beta;
    offspring_percentage = params.c_percentage;         % Number of offsprings as percentage of Population Pool size (default = 1)
    offspring_PopSize = round(offspring_percentage*Parent_PopSize/2)*2;        % Children population size outside the population pool (Even number)
                                                % Two parents have two chidrens, therefore a even number 
    mutation_rate = params.mutation_rate;
                                                
    
    %% Initialization
    
    % Template for Empty Individuals
    empty_individual.Position = [];             % Parameters list
    empty_individual.Cost = [];                 % Cost
    
    % Best Solution Ever Found
    GlobalBest.Position = [];
    
    if FindMin
        GlobalBest.Cost = inf;                  % inf for find the minimum, -inf for find the maximum
    else
        GlobalBest.Cost = -inf;
    end
    
    % Create an empty popolation
    Parent_pop = repmat(empty_individual, Parent_PopSize, 1);    
    
    % Fill the population with random individual position (parameters)
    for i = 1:Parent_PopSize
        Parent_pop(i).Position = randi([0, 1], 1, nVar);        % generate a random variable set
        
        % Evaluate the solutions
        Parent_pop(i).Cost = CostFunction(Parent_pop(i).Position);
        
        % Update the best variable, based on the cost
        if FindMin
            ParentCostUpdate = Parent_pop(i).Cost < GlobalBest.Cost;
        else
            ParentCostUpdate = Parent_pop(i).Cost > GlobalBest.Cost;
        end
            
        if ParentCostUpdate
            GlobalBest.Cost = Parent_pop(i).Cost;          % Or we can use (GlobalBest = pop(i);)
            GlobalBest.Position = Parent_pop(i).Position;
        end
    end
    
    % Record Best cost of the iterations
    BestCost_List = nan(MaxIt, 1);
    BestCandidate_List = [];
    
    
    %% Main loop (Two possible options: mutate the existing offspring pool, or create a new offspring pool for mutation (two additonal offspring pool (one not mutated, one mutated)))
    for it = 1:MaxIt
        
        % Selection Probabilities
        c = [Parent_pop.Cost];
        c_avg = mean(c);
        
        if c_avg ~= 0
            c = c/c_avg;                    % Normalize the cost list
        end
        score_list = exp(beta*c);
        
        % Initialize Offspring pool (double column matrix, with even number of elements)
        offspring_pop = repmat(empty_individual, offspring_PopSize/2, 2);   % Create an empty children popolation, each row is two new offsprings
        
        %%% Crossover
        for k = 1:offspring_PopSize/2
            
            % Select two different Parents
            parent1 = Parent_pop(RouletteWheelSelection(score_list));
            parent2 = Parent_pop(RouletteWheelSelection(score_list));
            
            % Crossover
            [offspring_pop(k, 1).Position, offspring_pop(k, 2).Position] = Crossover(parent1.Position, parent2.Position);
            
        end
        
        % Convert offspring pool to a single-column Matrix
        offspring_pop = offspring_pop(:);
        
        %%% Mutation
        for l = 1:offspring_PopSize
            
            % Perform Mutation
            offspring_pop(l).Position = Mutate(offspring_pop(l).Position, mutation_rate);
            
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
        
        
        % Merge Populations
        Parent_pop = [Parent_pop; offspring_pop];
        
        %%% Sort Population
        [~, sorted_Order] = sort([Parent_pop.Cost]);
        
        
        if FindMin
            Parent_pop = Parent_pop(sorted_Order);  
        else
            Parent_pop = Parent_pop(flip(sorted_Order));            % flip sorted_Order for find the maximum
        end
        
        %%% Remove Extra Individuals
        Parent_pop = Parent_pop(1: Parent_PopSize);
        
        %%% Record Best Cost of Iteration
        BestCost_List(it) = GlobalBest.Cost;
        BestCandidate_List = [BestCandidate_List; GlobalBest.Position];
        
        % Display Iteration Information
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(BestCost_List(it))]);
        disp(['Best Solution = ' num2str(GlobalBest.Position)]);
        disp('******************************************************');
        
    end
    
    
    %% Results
    output.pop = Parent_pop;
    output.GlobalBest = GlobalBest;
    output.BestCost_List = BestCost_List;
    output.BestCandidate_List = BestCandidate_List;
    
end














