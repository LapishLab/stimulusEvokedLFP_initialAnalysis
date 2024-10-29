function plotMovie(slicedData)
    numTrials = size(slicedData,3);
    ymax = max(slicedData(:)) * .75;
    ymin = min(slicedData(:)) * .75;
    for i=1:10:numTrials
        plotMeanAndSEM([],slicedData(:,:,i),{})
        yline(0)
        ylim([ymin,ymax])
        xlabel('Time')
        ylabel('Voltage')
        title(num2str(i))
        pause(.01)
    end
end