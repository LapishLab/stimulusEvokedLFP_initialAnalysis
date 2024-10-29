function data = getData(recording)
    % get stream name (assuming only 1 OE_FPGA_Acquisition_Board-108)
    streamNames = recording.continuous.keys();
    streamName = streamNames{1};
    
    % Get the continuous data from the current stream/recording
    data = recording.continuous(streamName);
end