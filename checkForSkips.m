recording = loadRecording(pwd());
%%
data = getData(recording);

%%
ch = 1;
downsample = 100;

x = data.timestamps(1:downsample:end);
y = data.samples(ch, 1:downsample:end);
scatter(x,y, '.')
xlabel('Time (s)')
ylabel('Voltage')
%%
data.timestamps(end)/60