function [Offspring1, Offspring2] = SinglePointCrossover(Parent1, Parent2)

    nVar = numel(Parent1);          % Detect number of variables
    
    j = randi([1, nVar-1]);         % Generate a random break point
    
    Offspring1 = [Parent1(1:j) Parent2(j+1:end)];       % First offspring
    Offspring2 = [Parent2(1:j) Parent1(j+1:end)];       % Second offspring

end
