% simulate using artificial matrices

%% init
% clear workspace
clearvars();

% paths
addpath(genpath('./Helper Functions/'));
addpath(genpath('./Helper Functions/mi/'));
addpath(genpath('./BCT/'));

% load settings
settings = Settings();

% focal or diffuse injury
settings.focal = false;

% distance matrix
Dist = DistMatrix(settings.N);

%% single simulation
for n_d = 500:25:500
    [C_t, E_t, L_s] = NMM(settings, Dist, true, n_d);
    C = squeeze(C_t(settings.steps, :, :));
    heatmap(C);
    
    % save plot to some reasonable destination
    filename = sprintf('./fig/model_%d.png', n_d);
    saveas(gcf, filename);
    
    %% stability plot
    duration = 2000;
    con = C_t(settings.steps - duration + 1 : settings.steps, 1, 10);
    filename = sprintf('./R/Results/stability/model_%d.csv', n_d);
    csvwrite(filename, con);
    
end
%% save excitation through time
% csvwrite('./R/Results/simulation/E_t.csv', E_t);

%% simulation plot
%M_t = MetricsThroughTime(C_t);
%csvwrite('./R/Results/simulation/M_t_model.csv', M_t);

%% three matrices collage
% C_h = squeeze(C_t(settings.steps / 2, :, :));
% C_i = squeeze(C_t((settings.steps / 2) + 1, :, :));
% csvwrite('./R/Results/matrices/C_h.csv', C_h);
% csvwrite('./R/Results/matrices/C_i.csv', C_i);
% csvwrite('./R/Results/matrices/L_s.csv', L_s);



%% power spectrum
% most injured node
% L_n = sum(L_s);
% [~, ix] = max(L_n);
% 
% duration = 50000;
% pre = (settings.steps / 2 - duration + 1 : settings.steps / 2);
% post = (settings.steps / 2 + 1 : settings.steps / 2 + duration);
% 
% Fs = 700;
% [preF, preP] = PowerSpectrum(E_t(ix, pre), Fs);
% [postF, postP] = PowerSpectrum(E_t(ix, post), Fs);
% PS_most_pre = [preF; preP'];
% PS_most_post = [postF; postP'];
% 
% csvwrite('./R/Results/injury/PS_model_pre.csv', PS_most_pre);
% csvwrite('./R/Results/injury/PS_model_post.csv', PS_most_post);
