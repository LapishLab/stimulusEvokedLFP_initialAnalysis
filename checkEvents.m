recording = loadRecording(pwd());

eventProcessors = recording.ttlEvents.keys();
processor = eventProcessors{1};
events = recording.ttlEvents(processor);

lines = sort(unique(events.line));


figure(1); clf
for i=1:length(lines)
    inds = events.line == lines(i);
    x = events.timestamp(inds);
    y = events.state(inds);
    scatter(x,y,25,'filled')
    hold on
end
xlabel('time (s)')
ylabel('state')
ylim([-0.1,1.1])

l = strsplit(sprintf("line# %i\n", lines), '\n');
l = l(1:end-1);
legend(l, 'AutoUpdate','off')
yline(0,'k--')
yline(1,'k--')