function offspring_mutated = Mutate(offspring, mutation_rate, sigma)

    % generate a list with 0 and 1 based on the probability of the mutation rate
    flag = (rand(size(offspring)) < mutation_rate);
    
    % get a copy of the offspring
    offspring_mutated = offspring;
    
    % generate a gaussian random distribution list
    r = randn(size(offspring));
    
    % change the corresponding index of the copied offspring
    offspring_mutated(flag) = offspring(flag) + sigma*r(flag);       % corresponding Gaussian distribution number

end