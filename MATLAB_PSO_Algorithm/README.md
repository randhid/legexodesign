## The MATLAB implementation of Particle Swarm Optimization

The function **PSO.m** receives **Problems** and **parameters**

An example of PSO.m can be found in **PSO_function_test.m**, the function plots the best cost along with the iterations in both actual and semilogy scale

## **Problem properties**

  problem.CostFunction (example: problem.CostFunction = @(x) function(x);)
  
  problem.nVar (number of changing variables)
  
  problem.VarMin (the lowder boundary of the variables)
  
  problem.VarMax (the upper boundary of the variables)
  
  
## **parameters properties**

  params.MaxIt (Maximum Number of Iterations)
  
  params.nPop (Population Size (Swarm Size))
  
  params.w  (Inertia Coefficient)
  
  params.wdamp (Damping Ratio of Inertia Coefficient)
  
  params.c1 (Personal Acceleration Coefficient)
  
  params.c2 (Social Acceleration Coefficient)
  
  params.ShowIterInfo (=true to show the iterations)
  
  
## **Returns**

  result = PSO(problem, params);
  
  result.last_it_pop (the particles within the last iteration)
  
  result.BestCosts_list (the best global cost within each iterations)
  
  result.GlobalBest (the best particle after all the iteration)
  
  
  
  
