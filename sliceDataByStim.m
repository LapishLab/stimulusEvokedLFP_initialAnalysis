function slicedData = sliceDataByStim(data,stimTimes,windowTime)
    nchannels = size(data.samples,1);
    period = mean(diff(data.timestamps));

    windowPoints = round(windowTime/period);
    numPulses = length(stimTimes);

    slicedData = data;
    slicedData.dimensions = ['probe channels', 'time', 'pulses'];
    slicedData.samples = nan( ...
        nchannels, ...
        windowPoints, ...
        numPulses ...
        );

    for i = 1:numPulses
        startInd = find(stimTimes(i)<data.timestamps, 1);
        stopInd = startInd + windowPoints - 1;
        slicedData.samples(:,:,i) = data.samples(:, startInd:stopInd);
    end

    slicedData.timestamps = data.timestamps(startInd:stopInd) - data.timestamps(startInd);
    slicedData.sampleNumbers = [];
end