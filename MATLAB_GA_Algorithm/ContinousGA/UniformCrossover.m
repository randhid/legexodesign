function [Offspring1, Offspring2] = UniformCrossover(Parent1, Parent2)

    % variable for increasing the alpha size 
    gamma = 0.1;

    % create a random list from 0 to 1 represent the corresponding inherent portion
    % alpha = rand(size(Parent1));
    alpha = unifrnd(-gamma, 1+gamma, size(Parent1));        % increase alpha size
    
    % offspring 1 take the first portion, offspring 2 take the second portion.
    Offspring1 = alpha.*Parent1 + (1-alpha).*Parent2;
    Offspring2 = (1-alpha).*Parent1 + alpha.*Parent2;

end