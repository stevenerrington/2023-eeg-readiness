
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


%% Analyse: Get ERP for left/rightward saccades, for lateralized channels.

describe_rp

