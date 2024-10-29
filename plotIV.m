clear
%% Variables you might want to change
currents = 50:50:500; % List of current amplitudes 
windowTime = 0.4; % Length of data to sample after stimulus (seconds)
downSampledRate = 1; % new sample rate in kHz

channelsToUse = 1:64;

%% Load entire recording (takes a long time)
fprintf('Select OpenEphys recording folder (e.g. 2024-10-28_14-52-49) \n')
recording = loadRecording(uigetdir());

%% Get stimulus ON timestamps and full LFP recording
stimTimes = getStimTimes(recording);
data = getData(recording);
data = downsampleData(data, downSampledRate);
clear recording % get rid of recording variable to free up memory


%% cut out channels
data.samples = data.samples(channelsToUse,:);
%% Slice the data by stimulus onset
slicedData = sliceDataByStim(data,stimTimes,windowTime);

%% Reshape the data into current amplitude groups
shapedData = reshapeByCurrent(slicedData, currents);

%% Figures
figure(1); clf
plotOverallMean(slicedData)

figure(2); clf
plotContactResp(shapedData)

figure(3); clf
plotResponseByGroups(shapedData)

peaks = getPeakResponse(shapedData);

figure(4); clf
plotPeaks(currents,peaks)

figure(5); clf
calcStimHalfMax(currents, peaks)

% figure(5)
% plotMovie(slicedData)

%%
%goodChannels = getPCA(shapedData);