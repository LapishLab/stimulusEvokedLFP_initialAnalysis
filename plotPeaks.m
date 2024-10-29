function plotPeaks(current,peaks)
    plotMedianAndMAD(current,peaks,{});
    yline(0)
    ylabel('Voltage (arbitrary)')
    xlabel('Current')
end