## The MATLAB implementation of Particle Swarm Optimization

The function **PSO.m** receives **problems** and **parameters**

An example of PSO.m can be found in **ParticleSwarmOptimization.m**, the function finds the best 5 variables that make the output of the **sphere.m** function smallest, and plots the best result along with the iterations in both actual and semilogy scale

## **problem properties**

  problem.CostFunction (example: problem.CostFunction = @(x) function(x);)
  
  problem.nVar (number of changing variables)
  
  problem.VarMin (the lowder boundary of the variables)
  
  problem.VarMax (the upper boundary of the variables)
  
  problem.FindMin (=true to solve for the minimum, Solve for the maximum or minimum)
  
  
## **parameters properties**

  params.MaxIt (Maximum Number of Iterations)
  
  params.nPop (Population Size (Swarm Size))
  
  params.w  (Inertia Coefficient)
  
  params.wdamp (Damping Ratio of Inertia Coefficient)
  
  params.c1 (Personal Acceleration Coefficient)
  
  params.c2 (Social Acceleration Coefficient)
  
  params.ShowIterInfo (=true to show the iterations)
  
  
## **Returns**

  **result = PSO(problem, params);**
  
  result.last_iteration_pop (the particles within the last iteration)
  
  result.BestCosts_List (the best global cost within each iterations)
  
  result.BestCandidate_List  (the best parameters through all the iterations)
  
  result.GlobalBest (the best particle after all the iteration)
  
## **Analyze data**

  the best parameters can be found in **result.GlobalBest.Position**
  
  the best cost can be found in **result.GlobalBest.Cost**
  
  
