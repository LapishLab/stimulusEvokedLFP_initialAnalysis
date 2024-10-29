function stimTimes = getStimTimes(recording, line)
    % get Event Processor name (assuming only 1 OE_FPGA_Acquisition_Board-108)
    eventProcessors = recording.ttlEvents.keys();
    processor = eventProcessors{1};
    events = recording.ttlEvents(processor);
    stimTimes = events.timestamp(events.state==1 & events.line==line);
    stimOff = events.timestamp(events.state==0 & events.line==line);

    if(length(stimTimes) ~= length(stimOff))
        warning(['A different number of Event Onset and Offset times' ...
            ' were recorded: Onsets=%i, Offsets=%i'] ...
            , length(stimTimes), length(stimOff))
    end

    stimDiff = stimOff - stimTimes;

    if(any(stimDiff<0))
        warning('A stimulus Offset was recorded before a stimulus Onset')
    end

    % figure(123); clf; 
    % scatter(stimTimes, ones(length(stimTimes)), '.g')
    % hold on;
    % scatter(stimOff, zeros(length(stimOff)), '.r')
    % 
    % figure(123); clf
    % histogram(stimDiff)
end