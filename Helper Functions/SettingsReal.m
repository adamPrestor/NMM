function settings = SettingsReal()
  %% development phase
  settings.N = 90; % connectome size
  settings.steps = 200000; % duration
  settings.mu = 3; % gain factor for coupling between NMM
  settings.a_sdp = 0.0005; % SDP step size, 0 means no SDP
  settings.b_sdp = 13;
  settings.a_gdp = 0.00001; % GDP step size, 0 means no GDP
  settings.c_gdp = 0.4;
  settings.a_ss = 0.5; % synaptic scaling strength
  
  %% recovery phase
  settings.injury = false; % enable or disable injuries
  settings.t_l = settings.steps; % timestep at which the injury occurs
  if (settings.injury)
    settings.steps = 2 * settings.steps;
  end
  
  %% track matrix through time
  settings.trackMatrix = true;
  
  %% neural oscillation
  settings.gammaHighWidth = 8; % 8.66 tbe - 70Hz
  settings.gammaWidth = 20; % 30Hz
  settings.betaWidth = 47;  % 46.62 tbe - 13Hz
  settings.alphaWidth = 76; % 75.75 tbe - 8Hz
  settings.thetaWidth = 152; % 151.51 tbe - 4Hz
end