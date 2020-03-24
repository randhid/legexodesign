import numpy as np
import matplotlib.pyplot as plt
from ToolClasses import ProblemClass, ParamsClass           # import tools
from CostFunction import *                                  # import cost function
from GA_Function import *                                   # import GA

################################################################################################
# Problem Definition
problem = ProblemClass()
problem.CostFunction = sphere
problem.nVar = 5
problem.VarMin = [-1, 8, -1, -1, -1]
problem.VarMax = [10, 10, 10, 10, 10]
problem.FindMin = True

################################################################################################
# GA Parameters
params = ParamsClass()
params.MaxIt = 400
params.nPop = 200
params.beta = 1
params.offspring_percentage = 1
params.Mutation_rate = 0.001
params.ShowIterInfo = True

################################################################################################
# Run GA
result = GA(problem, params)
print("Best Cost = {}".format(result.GlobalBest.cost))
print("Best Solution = {}".format(result.GlobalBest.position))

################################################################################################
# Results
plt.plot(result.BestCosts_List)
# plt.semilogy(result.BestCosts_List)
plt.xlim(0, params.MaxIt)
plt.xlabel('Iterations')
plt.ylabel('Best Cost')
if problem.FindMin:
    plt.title('(GA) Minimum Convergent Plot')
else:
    plt.title('(GA) Maximum Convergent Plot')
plt.grid(True)

plt.show()