clear
%% Variables you might want to change
windowTime = 0.4; % Length of data to sample after stimulus (seconds)
downSampledRate = 1; % new sample rate in kHz
channelsToUse = 1:64;

%% Load entire recording (takes a long time)
fprintf('Select OpenEphys recording folder (e.g. 2024-10-28_14-52-49) \n')
recording = loadRecording(uigetdir());

%% Get stimulus ON timestamps and full LFP recording
stimTimes = getStimTimes(recording, 1);
data = getData(recording);
data = downsampleData(data, downSampledRate);
clear recording % get rid of recording variable to free up memory

%% cut out channels
data.samples = data.samples(channelsToUse,:);

%% Slice the data by stimulus onset
slicedData = sliceDataByStim(data,stimTimes,windowTime);
