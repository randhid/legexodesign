## The MATLAB implementation of Genetic Algorithm

The function **GA.m** receives **problems** and **parameters**

An example of GA.m can be found in **GeneticAlgorithm.m**, the function finds the best 6 variables that make the output of the **sphere.m** function minimum, and plots the best result along with the iterations.

## **problem properties**

  problem.CostFunction (example: problem.CostFunction = @(x) function(x);)
  
  problem.nVar (number of changing variables)
  
  problem.VarMin (the lowder boundary of the variables)
  
  problem.VarMax (the upper boundary of the variables)
  
  problem.FindMin (=true to solve for the minimum, Solve for the maximum or minimum)
  
  
## **parameters properties**

  params.MaxIt (Maximum Number of Iterations)
  
  params.nPop (Population Size (parent population size))
  
  params.beta  (Parent score coefficient (<0 for find the minimum, >0 for find the maximum))
  
  params.c_percentage (Percentage of offspring compare to Population size)
  
  params.mutation_rate (Mutation rate of GA)
  
  params.sigma (standard deviation of the gaussian noise in the mutation)
  
  params.ShowIterInfo (=true to show the iterations)
  
  
## **returns**

  **result = GA(problem, params);**
  
  result.last_iteration_pop (the parameters within the last iteration)
  
  result.BestCosts_List (the best global cost within each iterations)
  
  result.BestCandidate_List  (the best parameters through all the iterations)
  
  result.GlobalBest (the best particle after all the iteration)
  
## **analyze data**

  the best parameters can be found in **result.GlobalBest.Position**
  
  the best cost can be found in **result.GlobalBest.Cost**
  
  
