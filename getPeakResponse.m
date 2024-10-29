function peaks = getPeakResponse(data)
    v = data.samples;
    m = mean(v, [1,3,4]);
    m = abs(m);
    [~, maxInd] = max(m);

    peaks = v(:,maxInd,:,:);
    peaks = mean(peaks,1);
    peaks = squeeze(peaks);
end