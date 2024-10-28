clear
%% Variables you might want to change
recFolder
windowTime = 0.4;
downsampleFactor = 30; % Warning, changing this will make time scale incorrect 
currents = 1:10;
%% Load entire recording (takes a long time)
recording = loadRecording(rec_folder);

%% Get stimulus ON timestamps and full LFP recording
stimTimes = getStimTimes(recording);
data = getData(recording);
data = downsampleData(data, downsampleFactor);
clear recording % get rid of recording variable to free up memory

%% Slice the data by stimulus onset
slicedData = sliceDataByStim(data,stimTimes,windowTime);

%% Reshape the data into current amplitude groups
shapedData = reshapeByCurrent(slicedData, currents);

%% Figures
figure(1)
plotOverallMean(slicedData)

figure(2)
plotContactResp(shapedData)

figure(3)
plotResponseByGroups(shapedData)

peaks = getPeakResponse(shapedData);
%%
figure(4)
plotPeaks(currents,peaks)

% figure(5)
% plotMovie(slicedData)

%% Functions
function plotMovie(slicedData)
numTrials = size(slicedData,3);
ymax = max(slicedData(:)) * .75;
ymin = min(slicedData(:)) * .75;
for i=1:10:numTrials
    addShadedLine([],slicedData(:,:,i),{})
    yline(0)
    ylim([ymin,ymax])
    xlabel('Time')
    ylabel('Voltage')
    title(num2str(i))
    pause(.01)
end

end

function peaks = getPeakResponse(shapedData)
    m = mean(shapedData, [1,3,4]);
    m = abs(m);
    [~, maxInd] = max(m);

    peaks = shapedData(:,maxInd,:,:);
    peaks = mean(peaks,1);
    peaks = squeeze(peaks);
end

function plotPeaks(current,peaks)
    addShadedLine(current,peaks,{});
    yline(0)
    ylabel('Voltage (arbitrary)')
    xlabel('Current')
end

function plotOverallMean(slicedData)
    m = squeeze(mean(slicedData, 1)); % average across probes
    addShadedLine([],m',{})
    yline(0)
    xlabel('Time (ms)')
    ylabel('Voltage (arbitrary)')
    title('Overall Mean')
end

function plotContactResp(shapedData)
    m = mean(shapedData, [3,4]);
    m = squeeze(m);
    imagesc(m)
    ylabel('Probe contact')
    xlabel('Time (ms)')
    c = colorbar;
    c.Label.String = 'Voltage';
end

function plotResponseByGroups(shapedData)
    m = mean(shapedData, 1);% average together probe contacts
    numGroups = size(m,4);
    avg = squeeze(mean(m, 3)); % average identical pulse amplitudes
    err = squeeze(std(m, 0, 3) / sqrt(size(m, 3))); % SEM accross pulse amplitudes
    title('Response across amp groups')
    tiledlayout(numGroups, 1)
    minY = min(avg(:));
    maxY = max(avg(:));
    for i = 1:numGroups
        nexttile
        errorbar(avg(:,i),err(:,i))
        ylim([minY,maxY])
        set(gca,'xtick',[])
        yline(0)
    end
    xlabel('Time')
    set(gca,'xtick',0:50:1000)
end

function shapedData = reshapeByCurrent(slicedData, currents)
    sz = size(slicedData);
    numCurrents = length(currents);
    pulsePerGroup = sz(3) / numCurrents;
    if pulsePerGroup ~= round(pulsePerGroup)
        error(['Number of ON events does not evenly divide by' ...
            ' the number of currents listed: ' ...
            '%i ON events detected, ' ...
            '%i currents listed'], sz(3), numCurrents);
    end
    shapedData = reshape(slicedData, sz(1),sz(2),pulsePerGroup,numCurrents);
end

function slicedData = sliceDataByStim(data,stimTimes,windowTime)
    nchannels = size(data.samples,1);
    period = mean(diff(data.timestamps));

    windowPoints = round(windowTime/period);
    numPulses = length(stimTimes);
    
    slicedData = nan( ...
        nchannels, ...
        windowPoints, ...
        numPulses ...
        );

    for i = 1:numPulses
        startInd = find(stimTimes(i)<data.timestamps, 1);
        stopInd = startInd + windowPoints - 1;
        slicedData(:,:,i) = data.samples(:, startInd:stopInd);
    end
end

function recording = loadRecording(rec_path)
    session = Session(rec_path);
    % Only look at the first record node for now (assume their will only be 1)
    node = session.recordNodes{1};
    % Only look at the first recording for now (assume their will only be 1)
    recording = node.recordings{1,1};
end

function data = getData(recording)
    % get stream name (assuming only 1 OE_FPGA_Acquisition_Board-108)
    streamNames = recording.continuous.keys();
    streamName = streamNames{1};
    
    % Get the continuous data from the current stream/recording
    data = recording.continuous(streamName);
end


function data = downsampleData(data, downSampleFactor)
    data.timestamps = data.timestamps(1:downSampleFactor:end);
    data.samples = data.samples(:, 1:downSampleFactor:end);
    % data.timestamps = decimate(data.timestamps, downSampleFactor, "fir");
    % nContacts = size(data.samples, 1);
    % newSamples = nan(nContacts, length(data.timestamps));
    % for i=1:nContacts
    %     newSamples(i, :) = decimate(double(data.samples(i,:)), downSampleFactor);
    % end
    data.sampleNumbers = [];
end

function stimTimes = getStimTimes(recording)
    % get Event Processor name (assuming only 1 OE_FPGA_Acquisition_Board-108)
    eventProcessors = recording.ttlEvents.keys();
    processor = eventProcessors{1};
    events = recording.ttlEvents(processor);
    stimTimes = events.timestamp(events.state==1);
    stimOff = events.timestamp(events.state==0);

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