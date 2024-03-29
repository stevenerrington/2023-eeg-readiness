
%% Setup: Setup workspace and define parameters
% Clear workspace and console
clear all; clc

% Define key directories
dirs = get_dirs_rp('home');

% Load datafiles
load(fullfile(dirs.root, 'data' ,'bayesianSSRT')); 
load(fullfile(dirs.root, 'data' ,'executiveBeh')); 
load(fullfile(dirs.root, 'data' ,'FileNames')); 

% Run parameter scripts
getColors_rp;

% Setup analysis parameters
params.ephys.samplingFreq = 1000;

params.alignment.alignWin = [-1000 2000];
params.alignment.time = params.alignment.alignWin(1):...
    params.alignment.alignWin(end)-1;

params.eventNames = {'fixate','target','stopSignal','saccade','sacc_end','tone','reward','sec_sacc'};

%% Extract: Convert raw EEG data into trial-by-trial event-related potentials.
extract_signal

%% Analyse: Saccade RT for left and right targets
describe_rt_leftright

%% Analyse: Show saccade production metrics
describe_example_eyePos

%% Analyse: produce race model figures
describe_stop_beh

%% Analyse: Get ERP for left/rightward saccades, for lateralized channels.
describe_rp_saccade
describe_rp_target
describe_windowROC
describe_temporalROC

%% Analyse: look at ERP for slow, medium, and fast saccades
describe_rp_rt

%% Analyse: Get ERP for stopping
describe_rp_stopping
describe_stopping_windowROC

%% Analyse: Get ERP for fast and slow no-stop RTs
% Peak of target align and saccade align
describe_rt_analyses

%% Analyse: Get ERP for low and high value
% Peak of target align and saccade align
describe_value_analyses

%% Analyse: Test whether signal is goal specific or not
extract_iti_saccade
compare_goal_nongoal_amp





