function output = GA(problem, params)

    %% Problem definition
    CostFunction = problem.CostFunction;        % Cost function
    nVar = problem.nVar;                        % number of changing variables
    
    
    %% GA Parameters
    MaxIt = params.MaxIt;                       % Maximum number of GA iterations
    Parent_PopSize = params.nPop;                         % Population Pool size
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
    GlobalBest.Cost = inf;                      % inf for find the minimum, -inf for find the maximum
    
    % Create an empty popolation
    Parent_pop = repmat(empty_individual, Parent_PopSize, 1);    
    
    % Fill the population with random individual position (parameters)
    for i = 1:Parent_PopSize
        Parent_pop(i).Position = randi([0, 1], 1, nVar);
        
        % Evaluate the solutions
        Parent_pop(i).Cost = CostFunction(Parent_pop(i).Position);
        
        % Update the best variable, based on the cost
        if Parent_pop(i).Cost < GlobalBest.Cost
            GlobalBest.Cost = Parent_pop(i).Cost;          % Or we can use (GlobalBest = pop(i);)
            GlobalBest.Position = Parent_pop(i).Position;
        end
    end
    
    % Record Best cost of the iterations
    BestCost_List = nan(MaxIt, 1);
    BestCandidate_List = [];
    
    
    %% Main loop (Two possible options: mutate the existing offspring pool, or create a new offspring pool for mutation (two additonal offspring pool (one not mutated, one mutated)))
    for it = 1:MaxIt
        
        % Initialize Offspring pool (double column matrix, with even number of elements)
        offspring_pop = repmat(empty_individual, offspring_PopSize/2, 2);   % Create an empty children popolation, each row is two new offsprings
        
        %%% Crossover
        for k = 1:offspring_PopSize/2
            
            % Select two different Parents
            population_index = randperm(Parent_PopSize);
            parent1 = Parent_pop(population_index(1));
            parent2 = Parent_pop(population_index(2));
            
            % Single Point Crossover
            [offspring_pop(k, 1).Position, offspring_pop(k, 2).Position] = SinglePointCrossover(parent1.Position, parent2.Position);
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
            if offspring_pop(l).Cost < GlobalBest.Cost
                GlobalBest = offspring_pop(l);          % Or we can use (GlobalBest = pop(i);)
            end
        end
        
        
        % Merge Populations
        Parent_pop = [Parent_pop; offspring_pop];
        
        %%% Sort Population
        [~, sorted_Order] = sort([Parent_pop.Cost]);
        Parent_pop = Parent_pop(sorted_Order);
        
        
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














