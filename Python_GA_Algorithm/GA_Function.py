import numpy as np
import copy
from ToolClasses import EmptyIndividual, ResultClass     # import tools

################################################################################################
def GA(problem, params):
    
    # Problem Definition
    CostFunction = problem.CostFunction     # Cost fucntion
    nVar = problem.nVar                     # Number of variables
    VarMin = problem.VarMin                 # Lower bound
    VarMax = problem.VarMax                 # Upper bound
    FindMin = problem.FindMin               # find minimum or maximum

    # GA Parameters
    MaxIt = params.MaxIt                    # Maximum number of iterations
    nPop = params.nPop                      # parent population
    beta = params.beta                      # Parent score coefficient for picking parents(<0 for find the minimum, >0 for find the maximum)
    offspring_percentage = params.offspring_percentage      # Percentage of offspring compare to Population size
    offspring_PopSize = int(np.round(offspring_percentage*nPop/2)*2)     # two parents have two offsprings
    Mutation_rate = params.Mutation_rate    # Mutation rate of GA
    ShowIterInfo = params.ShowIterInfo      # =true to show the iterations

    ################################################################################################
    # Best Individual (best parameters and best cost)
    BestIndividual = EmptyIndividual()

    # inf for find minimum, -inf for find the maximum
    if FindMin:
        BestIndividual.cost = np.inf
    else:
        BestIndividual.cost = -np.inf

    # flag for update the best
    UpdateFlag = None

    ################################################################################################
    # Initial parent population with empty Individual Template
    parent_pop = []

    for i in range(nPop):
        empty_individual = EmptyIndividual()
        empty_individual.position = np.random.uniform(VarMin, VarMax, nVar)     # Generate random variables
        empty_individual.cost = CostFunction(empty_individual.position)         # Get the score
        parent_pop.append(empty_individual)                                     # Add individual into the population

        # find the minimum or maximum based on the user input
        if FindMin:
            UpdateFlag = empty_individual.cost < BestIndividual.cost
        else:
            UpdateFlag = empty_individual.cost > BestIndividual.cost

        # update the best individual (make a deep copy)
        if UpdateFlag:
            BestIndividual = copy.deepcopy(empty_individual)


    ################################################################################################
    # record the best cost and candidate along the iterations
    BestCosts_List = np.empty(MaxIt)
    BestCandidates_List = []


    ################################################################################################
    # Main loop
    for it in range(MaxIt):

        ################################################################################################
        # store all the costs of parents in a list
        costs = np.array([x.cost for x in parent_pop])

        # calculate the average cost
        avg_cost = np.mean(costs)

        # normalize the costs if the cost mean is not zero
        if avg_cost != 0:
            costs /= avg_cost

        # differentiate the parents based on there score
        score_list = np.exp(beta*costs)

        ################################################################################################
        # offspring population
        offspring_pop = []

        for k in range(offspring_PopSize//2):
            
            # # random permutation
            # q = np.random.permutation(nPop)

            # # pick two parents randomly
            # parent1 = parent_pop[q[0]]
            # parent2 = parent_pop[q[1]]

            ################################################################################################
            # roulette_wheel_selection
            parent1 = parent_pop[roulette_wheel_selection(score_list)]
            parent2 = parent_pop[roulette_wheel_selection(score_list)]

            ################################################################################################
            # crossover
            offspring1, offspring2 = crossover(parent1, parent2)

            ################################################################################################
            # mutation
            offspring1 = mutation(offspring1, Mutation_rate)
            offspring2 = mutation(offspring2, Mutation_rate)

            ################################################################################################
            # apply boundaries
            offspring1 = apply_bound(offspring1, VarMin, VarMax)
            offspring2 = apply_bound(offspring2, VarMin, VarMax)

            # evaluate the offsprings
            offspring1.cost = CostFunction(offspring1.position)
            offspring2.cost = CostFunction(offspring2.position)


            # Update the best if there is one
            if FindMin:
                UpdateFlag = offspring1.cost < BestIndividual.cost
            else:
                UpdateFlag = offspring1.cost > BestIndividual.cost

            if UpdateFlag:
                BestIndividual = copy.deepcopy(offspring1)

            if FindMin:
                UpdateFlag = offspring2.cost < BestIndividual.cost
            else:
                UpdateFlag = offspring2.cost > BestIndividual.cost

            if UpdateFlag:
                BestIndividual = copy.deepcopy(offspring2)
            


            # update the offspring population
            offspring_pop.append(offspring1)
            offspring_pop.append(offspring2)


        ################################################################################################
        # Merge the parents and offsprings
        parent_pop += offspring_pop

        # Sort the population based on the cost
        if FindMin:
            parent_pop = sorted(parent_pop, key = lambda x: x.cost, reverse=False)
        else:
            parent_pop = sorted(parent_pop, key = lambda x: x.cost, reverse=True)

        # Trim the extra individuals
        parent_pop = parent_pop[0: nPop]

        ################################################################################################
        # store the best cost and candidate along the iterations
        BestCosts_List[it] = BestIndividual.cost
        BestCandidates_List.append(BestIndividual.position)

        # show information
        if ShowIterInfo:
            if FindMin:
                print("Finding Minimum....")
            else:
                print("Finding Minimum....")
            print("Iteration {}: Best Cost = {}".format(it, BestIndividual.cost))
            print("Best Solution = {}".format(BestIndividual.position))
            print("*****************************************************")



    ################################################################################################
    # result
    result = ResultClass()
    result.last_iteration_pop = parent_pop
    result.BestCosts_List = BestCosts_List
    result.BestCandidates_List = BestCandidates_List
    result.GlobalBest = BestIndividual

    return result






################################################################################################
# TOOLS

# crossover function
def crossover(parent1, parent2):

    # make copies of parent 1 and 2
    offspring1 = copy.deepcopy(parent1)
    offspring2 = copy.deepcopy(parent2)

    #extened range from [0, 1)
    gamma = 0.1

    # distinct call for random numbers
    alpha = np.random.uniform(-gamma, 1+gamma, *offspring1.position.shape)

    # crossover
    offspring1.position = alpha*parent1.position + (1-alpha)*parent2.position
    offspring2.position = (1-alpha)*parent1.position + alpha*parent2.position


    return offspring1, offspring2



# mutation function
def mutation(offspring, Mutation_rate):

    # make a copy of the offspring
    mutated_offspring = copy.deepcopy(offspring)

    # create a random list from 0 to 1
    flag = np.random.rand(*offspring.position.shape) <= Mutation_rate

    # find the index that is true
    indexes = np.argwhere(flag)

    # standard deviation of the gaussian noise
    sigma = 0.1

    # mutate the corresponding indexes
    mutated_offspring.position[indexes] = offspring.position[indexes] + sigma*np.random.randn(*indexes.shape)

    return mutated_offspring



# apply boundaries
def apply_bound(offspring, VarMin, VarMax):

    # limit the minimum
    offspring.position = np.maximum(offspring.position, VarMin)

    # limit the maximum
    offspring.position = np.minimum(offspring.position, VarMax)

    return offspring



# Select parent based on the cost score
def roulette_wheel_selection(cost_list):

    # calculate the cum sum of the population cost list
    cumsum = np.cumsum(cost_list)

    # generate a random number within the cost range
    r = sum(cost_list)*np.random.rand()

    # find the index of cost greater than the random number
    indexes = np.argwhere(r <= cumsum)

    # return the first index
    return indexes[0][0] 