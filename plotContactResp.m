function plotContactResp(data)
    m = mean(data.samples, [3,4]);
    m = squeeze(m);
    imagesc(m)
    ylabel('Probe contact')
    xlabel('Time (ms)')
    c = colorbar;
    c.Label.String = 'Voltage';
end