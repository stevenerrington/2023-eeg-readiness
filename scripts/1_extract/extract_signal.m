for session = 1:29
    fprintf(' > Extracting EEG on session number %i of 29. \n',session);
    % Get session name (to load in relevant file)
    sessionName = FileNames{session};
    
    % Clear workspace
    clear trials eventTimes inputLFP cleanLFP alignedLFP filteredLFP betaOutput morletLFP pTrl_burst
    
    % Setup key behavior variables
    ssrt = bayesianSSRT.ssrt_mean(session);
    eventTimes = executiveBeh.TrialEventTimes_Overall{session};
    
    % Get trial indices
    trials.canceled = executiveBeh.ttm_CGO{session}.C_unmatched;
    trials.noncanceled = executiveBeh.ttx.NC{session};
    trials.nostop = executiveBeh.ttx.GO{session};
    
    % Load raw signal
    inputLFP = load(fullfile(dirs.raw_data,sessionName),...
        'AD01','AD02','AD03','AD04');
    
    % Pre-process & filter analog data (EEG/LFP), and align on event
    filter = 'all'; filterFreq = [1 30];
    
    channel_list = {'AD01','AD02','AD03','AD04'};
    
    for ch_index = 1:4
        
        EEG_signal_target = [];
        EEG_signal_saccade = [];
        
        channel = channel_list{ch_index};
        
        % Target aligned.
        params.alignment.eventN = 2;
        [~, EEG_signal_target] = tidy_signal(inputLFP.(channel), params.ephys, filterFreq,...
            eventTimes, params.alignment);
        
        % Saccade aligned.
        params.alignment.eventN = 4;
        [~, EEG_signal_saccade] = tidy_signal(inputLFP.(channel), params.ephys, filterFreq,...
            eventTimes, params.alignment);
        
        % Stop-signal aligned.
        params.alignment.eventN = 3;
        [~, EEG_signal_stopSignal] = tidy_signal(inputLFP.(channel), params.ephys, filterFreq,...
            eventTimes, params.alignment);
        
        
        if ismember(session,executiveBeh.nhpSessions.EuSessions) &...
                ch_index == 2; ch_index = 3;
        elseif ismember(session, executiveBeh.nhpSessions.EuSessions) &...
                ch_index == 3; ch_index = 2;
        end
        
        EEG_signal.target{session,ch_index} = EEG_signal_target;
        EEG_signal.saccade{session,ch_index} = EEG_signal_saccade;
        EEG_signal.stopSignal{session,ch_index} = EEG_signal_stopSignal;
        
    end
    
end
