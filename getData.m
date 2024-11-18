function data = getData(recording)
    % get stream name (assuming only 1 OE_FPGA_Acquisition_Board-108)
    streamNames = recording.continuous.keys();
    streamName = streamNames{1};
    
    % Get the continuous data from the current stream/recording
    data = recording.continuous(streamName);

    srWarningThreshold = 2;
    maxTimeDiff = max(diff(data.timestamps));
    if maxTimeDiff > srWarningThreshold/data.metadata.sampleRate
        msg = ['Max time Sample diff of %f s detected.' ...
            ' There may be skips in the data. This can occur if' ...
            ' write speed is too slow on the recording PC'];
        warning(msg, maxTimeDiff)
    end
end