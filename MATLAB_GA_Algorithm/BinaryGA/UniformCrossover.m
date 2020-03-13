function [Offspring1, Offspring2] = UniformCrossover(Parent1, Parent2)

    alpha = randi([0, 1], size(Parent1));
    
    Offspring1 = alpha.*Parent1 + (1-alpha).*Parent2;
    Offspring2 = (1-alpha).*Parent1 + alpha.*Parent2;

end