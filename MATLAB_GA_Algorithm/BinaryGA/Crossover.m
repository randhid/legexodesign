function [Offspring1, Offspring2] = Crossover(Parent1, Parent2)

    % randomly pick one of the crossover methods
    % Slightly more focous on the Uniform Crossover
    m = randi([1, 4]);
    
    switch m
        case 1
            % Single Point Crossover
            [Offspring1, Offspring2] = SinglePointCrossover(Parent1, Parent2);
            % disp('SinglePointCrossover');
        case 2
            % Double Point Crossover
            [Offspring1, Offspring2] = DoublePointCrossover(Parent1, Parent2);
            % disp('DoublePointCrossover');
        otherwise
            % Uniform Crossover
            [Offspring1, Offspring2] = UniformCrossover(Parent1, Parent2);
            % disp('UniformCrossover');
    end
    
end