function calcStimHalfMax(currents,peaks)
    p = median(peaks, 1);
    p = [0,p];
    currents = [0,currents];

    [~, maxInd] = max(abs(p)); 
    p = p / p(maxInd); 

    sigModel = fit(currents',p', 'logistic');
    halfMax = sigModel.c;

    plot(currents,p, 'k')
    hold on
    plot(sigModel)
    legend('Real','Fit', 'AutoUpdate','off','Location','west')

    xline(halfMax, '--r')
    ylim([-0.1,1.1])
    yline(0)
    yline(1)
    text(halfMax,.1, ['Half-Max = ', num2str(halfMax)])
end