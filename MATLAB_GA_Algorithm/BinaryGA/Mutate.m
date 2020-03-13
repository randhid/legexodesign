function offspring_mutated = Mutate(offspring, mutation_rate)

    flag = (rand(size(offspring)) < mutation_rate);
    
    offspring_mutated = offspring;
    offspring_mutated(flag) = 1 - offspring(flag);

end