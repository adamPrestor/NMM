memory = zeros(8, 4);
j = 1;

for n_d=25:25:200

    filename = sprintf('./R/Results/sdp_params/cov/%d.csv', n_d);
    params = load(filename);
    
    memory(j, :) = [max(params(:)), min(params(:)), mean(params(:)), std(params(:))];
    
    j = j+1;
end

memory