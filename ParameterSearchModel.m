% simulate using artificial matrices

%% init  
% clear workspace
clearvars();

% paths
addpath(genpath('./Helper Functions/'));
addpath(genpath('./BCT/'));

% a_sdp
a_sdp_m = 2; % min a_sdp
a_sdp_M = 8; % max a_sdp
s_a_sdp = 0.5; % a_sdp step

% b_sdp
b_sdp_m = 2; % min b_sdp
b_sdp_M = 4; % max b_sdp
s_b_sdp = 1; % b_sdp step

% c_gdp
c_gdp_m = 0.1; % min c_gdp
c_gdp_M = 0.2; % max c_gdp
s_c_gdp = 0.1; % c_gdp step

% a_gdp
a_gdp_m = 0.000000005; % min a_gdp
a_gdp_M = 0.000000025; % max a_gdp
s_a_gdp = 0.000000005; % a_gdp step

% number of steps
a_sdpSteps = ceil((a_sdp_M - a_sdp_m) / s_a_sdp) + 1;
b_sdpSteps = ceil((b_sdp_M - b_sdp_m) / s_b_sdp) + 1;
c_gdpSteps = ceil((c_gdp_M - c_gdp_m) / s_c_gdp) + 1;
a_gdpSteps = ceil((a_gdp_M - a_gdp_m) / s_a_gdp) + 1;

% index of current iteration
iteration = 1;
iterations = a_sdpSteps * b_sdpSteps * a_gdpSteps;
% variables to store results
M_temp = zeros(c_gdpSteps, 9);
M = zeros(iterations * c_gdpSteps, 9);
    
% artificial distance matrix
settings = Settings();
Dist = DistMatrix(settings.N);

% real dist matrix
%load('./Data/Dist90.mat');

%% simulate
for a_gdp = a_gdp_m:s_a_gdp:a_gdp_M
    for a_sdp = a_sdp_m:s_a_sdp:a_sdp_M
      for b_sdp = b_sdp_m:s_b_sdp:b_sdp_M
        tic
        ParforProgress(c_gdpSteps);
        parfor i = 1:c_gdpSteps
          % report
          ParforProgress;
    
          % parameters
          c_gdp = c_gdp_m + (i - 1) * s_c_gdp;
    
          % settings
          settings = Settings();
          settings.a_gdp = a_gdp;
          settings.a_sdp = a_sdp;
          settings.b_sdp = b_sdp;
          settings.c_gdp = c_gdp;
          
          % do not track matrix through time
          settings.trackMatrix = false;
          
          % run simulation
          [C_t, ~, ~] = NMM(settings, Dist, false);
    
          % metrics
          M_temp(i,:) = [a_sdp, b_sdp, c_gdp, a_gdp, Metrics(C_t)];
        end
    
        % metrics
        j = (iteration - 1) * c_gdpSteps;
        k = j + c_gdpSteps;
        M(j + 1:k, :) = M_temp;
    
        time = datetime('now','Format','HH:mm');
        elapsed = seconds(toc * (iterations - iteration));
        eta = time + elapsed;
        disp(['t: ', datestr(time), ' ETA: ', datestr(eta), ' (', num2str(iteration), '/', num2str(iterations), ')'])
    
        iteration = iteration + 1;
      end
    end
end

% save
csvwrite('./R/Results/model/M_parameters_cov_expended.csv', M);