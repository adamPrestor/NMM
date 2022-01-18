% simulate using artificial matrices

%% init
% clear workspace
clearvars();

% paths
addpath(genpath('./Helper Functions/'));
addpath(genpath('./BCT/'));

% load settings
settings = SettingsReal();
 
% do not track matrix through time
settings.trackMatrix = false;

% distance matrix
%Dist = DistMatrix(settings.N);
% real dist matrix
load('./Data/Dist90.mat');

%% simulate
for n_d = 20:5:100
    [C_t, E_t, L_s] = NMM(settings, Dist, true, n_d);
    heatmap(C_t);
    
    % save plot to some reasonable destination
    filename = sprintf('./fig/real_%d.png', n_d);
    saveas(gcf, filename);
end

%% metrics
M = Metrics(C_t);

%% save matrix
csvwrite('./R/Results/real/C.csv', C_t);
