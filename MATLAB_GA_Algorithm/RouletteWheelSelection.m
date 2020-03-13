function index = RouletteWheelSelection(score_list)

    % pick a random number within the maximum selection list range
    r = rand*sum(score_list);
    c = cumsum(score_list);
    
    % find the first index in the score list that make the random number smaller than the cumulated scores
    index = find(r <= c, 1, 'first');

end