function [filterLFP, alignedLFP] = tidy_signal_npSaccade(inputData, ephysParameters,...
    filterFreq, eventTimes, alignmentParameters)

% Filter LFP
filterLFP = filter_signal(inputData,filterFreq(1), filterFreq(2), ephysParameters.samplingFreq);

% Align LFP on ITI Saccade
alignedLFP = align_signal(filterLFP,...
    1:size(eventTimes,1),...
    eventTimes, 2, alignmentParameters.alignWin);

    
end
