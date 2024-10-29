function plotOverallMean(slicedData)
    m = squeeze(mean(slicedData.samples, 1)); % average across probes
    plotMeanAndSEM(slicedData.timestamps,m',{})
    yline(0)
    xlabel('Time (s)')
    ylabel('Voltage (arbitrary)')
    title('Overall Mean')
end