function index = RouletteWheelSelection(score_list)

    % pick a random number within the maximum selection list range
    r = rand*sum(score_list);
    c = cumsum(score_list);
    
    index = find(r <= c, 1, 'first');

end