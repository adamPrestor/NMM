function [oscillations, count] = Oscilations()
    data = {
        {'delta', 1, 4},
        {'theta', 4, 8},
        {'alpha', 8, 12},
        {'beta', 13, 30},
        {'low_gamma', 30, 70},
        {'high_gamma', 70, 150}
    };
    oscillations = data;
    count = size(data, 1);
end