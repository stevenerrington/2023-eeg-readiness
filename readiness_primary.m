
%% Setup: Setup workspace and define parameters
% Define key directories
dirs.root = 'D:\projectCode\2023-eeg-readiness\';
dirs.raw_data = 'D:\data\2012_Cmand_EuX\rawData\';
addpath(genpath(dirs.root));

% Load datafiles
load(fullfile(dirs.root, 'data' ,'bayesianSSRT')); 
load(fullfile(dirs.root, 'data' ,'executiveBeh')); 
load(fullfile(dirs.root, 'data' ,'FileNames')); 

% Run parameter scripts
getColors;

% Setup analysis parameters
params.ephys.samplingFreq = 1000;

params.alignment.alignWin = [-1000 2000];
params.alignment.time = params.alignment.alignWin(1):...
    params.alignment.alignWin(end)-1;

params.eventNames = {'fixate','target','stopSignal','saccade','sacc_end','tone','reward','sec_sacc'};

%% Extract: Convert raw EEG data into trial-by-trial event-related potentials.
if ~exist(fullfile(dirs.root,'data','EEG_signal.mat'))
    extract_signal
else
    load(fullfile(dirs.root,'data','EEG_signal.mat'))
end

%% Analyse: Get ERP for left/rightward saccades, for lateralized channels.

