function [filterLFP, alignedLFP] = tidy_signal(inputData, ephysParameters,...
    filterFreq, eventTimes, alignmentParameters)

% Filter LFP
filterLFP = filter_signal(inputData,filterFreq(1), filterFreq(2), ephysParameters.samplingFreq);

% Align LFP on stop-signal
alignedLFP = align_signal(filterLFP,...
    1:size(eventTimes,1),...
    eventTimes, alignmentParameters.eventN, alignmentParameters.alignWin);

end
