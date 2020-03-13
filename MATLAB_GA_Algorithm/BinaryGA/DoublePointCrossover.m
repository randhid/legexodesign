function [Offspring1, Offspring2] = DoublePointCrossover(Parent1, Parent2)

    nVar = numel(Parent1);          % Detect number of variables
    
    q = randperm(nVar);             % Select two different index
    j1 = min(q(1), q(2));           % first cutting point (infront of second cutting point)
    j2 = max(q(1), q(2));           % Second cutting point
    
    Offspring1 = [Parent1(1:j1) Parent2(j1+1:j2) Parent1(j2+1:end)];
    Offspring2 = [Parent2(1:j1) Parent1(j1+1:j2) Parent2(j2+1:end)];
    
end