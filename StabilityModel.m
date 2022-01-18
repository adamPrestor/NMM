% simulate using artificial matrices

%% init
% clear workspace
clearvars();

% paths
addpath(genpath('./Helper Functions/'));
addpath(genpath('./BCT/'));

% load settings
settings = Settings();

% focal or diffuse injury
settings.focal = false;

% set 400000 steps, the same as in case of Stam for stability exploration
settings.steps = 20000;

% start parameters
a_sdp = [0.003, 0.002, 0.001, 0.0005, 0.0001];
a_gdp = [0.0003, 0.0002, 0.0001, 0.00005, 0.00001];


% distance matrix
Dist = DistMatrix(settings.N);

for n_d = 500:25:500
    
    % number of iterations and the variable to store results
    iterations = 5; % originally: 10
    iteration = 0;
    steps = size(a_sdp, 2);
    R = zeros(steps*iterations, 3);
    
    for i = 1:iterations
        for j = 1:steps
            %% simulate
            iteration = iteration + 1;
            disp(['N_d selected ', num2str(n_d)])
            disp(['Processing: ', num2str(iteration), '/', num2str(steps*iterations)])
            
            settings.a_sdp = a_sdp(j);
            settings.a_gdp = a_gdp(j);

            % run
            [C_t, E_t, L_s] = NMM(settings, Dist, true, n_d);

            % extract once it is stable
            s = (size(C_t, 1)/2)+1;
            C_s = C_t(s:end,:,:);

            minC = ones(32);
            minC(logical(eye(size(minC)))) = 0;
            maxC = zeros(32);
            maxC(logical(eye(size(maxC)))) = 0;
            for k = 1:size(C_s, 1)
                C = squeeze(C_s(k,:,:));

                minC(C < minC) = C(C < minC);
                maxC(C > maxC) = C(C > maxC);
            end

            % calculate
            D = maxC - minC;
            maxD = max(max(D));

            R(iteration,:) = [maxD, a_sdp(j), a_gdp(j)];
        end
    end
    
    % save
    filename = sprintf('./R/Results/stability/Model_extensive_%d.csv', n_d);
    csvwrite(filename, R);

end