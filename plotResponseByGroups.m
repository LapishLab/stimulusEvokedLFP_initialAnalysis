function plotResponseByGroups(data)
    m = mean(data.samples, 1);% average together probe contacts
    numGroups = size(m,4);

    title('Response across amp groups')
    tiledlayout(numGroups, 1)
    minY = min(mean(m, 3), [], 'all');
    maxY = max(mean(m, 3), [], 'all');
    for i = 1:numGroups
        nexttile
        y = squeeze(m(:,:,:,i))';
        plotMeanAndSEM(data.timestamps*1000,y, {})
        ylim([minY,maxY])
        set(gca,'xtick',[])
        yline(0)
    end
    xlabel('Time (ms)')
    set(gca,'xtick',0:50:1000)
end
