recording = loadRecording(pwd());
%%
data = getData(recording);
%%
shunt_ind = strcmp(data.metadata.names, 'ADC1');
shuntVoltage = double(data.samples(shunt_ind, :)); 
shuntVoltage = shuntVoltage * data.metadata.channels(shunt_ind).bit_volts;
shunt_resistance = 15000;
current = shuntVoltage / shunt_resistance * 1E6; % Current in uA

%%
currDiff = diff(current);
threshold = std(double(currDiff))*6;

isPositive = max(current)>abs(min(current));
if isPositive
    currON = find(currDiff>threshold);
else
    threshold = threshold*-1;
    currON = find(currDiff<threshold);
end
repeats = 1+find(diff(currON)<10); % find any repeats within 10 sample points;
currON(repeats) = [];% remove any repeats 

figure(1); clf;
plot(data.timestamps(2:end), diff(current))
hold on
yline(threshold)
scatter(data.timestamps(currON), threshold, '*','r')
xlabel('time (s)')
ylabel('diff(current)')

%%
figure(2); clf; hold on
plot(data.timestamps, current)
scatter(data.timestamps(currON), 0, '*', 'r')
xlabel('time (s)')
ylabel('current (uA)')
%%
window_time_pre = 100; % time in microseconds
window_time_post = 400; % time in microseconds

winStart = currON - round(window_time_pre*1E-6*data.metadata.sampleRate);
winStop = currON + round(window_time_post*1E-6*data.metadata.sampleRate);

window = nan(length(winStart), winStop(1)-winStart(1)+1);
for i=1:length(winStart)
    window(i,:) = current(winStart(i):winStop(i));
end
win_time = 1E6*(data.timestamps(winStart(i):winStop(i)) - data.timestamps(winStart(i))) - window_time_pre;

figure(3); clf
plot(win_time,window')
%legend()
xlabel('time (us)')
ylabel('current (uA)')
xlim([-window_time_pre,window_time_post])


%% TEMP
% yline(0)
% yline(-35, '--')
% yline(-100, '--')
% yline(-200, '--')
% yline(-500, '--')
% 
% ylim([-550,10])
% 
% yline(500, '--')
% ylim([-10,550])