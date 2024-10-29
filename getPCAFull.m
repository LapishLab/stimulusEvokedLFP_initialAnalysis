function getPCAFull(slicedData)
    d = slicedData.samples;
    d(:,1,:) = nan; %set first timepoint to nan;
    d = permute(d, [2,1,3]); % time x probe x pulse 
    d = reshape(d, size(d,1), []); % time x probe/pulse
    
    [coeff,score,latent,tsquared,explained,mu] = pca(d);
    
    figure(123); clf
    tiledlayout(4,1)
    nexttile
    plot(score(:,1))
    nexttile
    plot(score(:,2))
    nexttile
    plot(score(:,3))
    nexttile
    plot(score(:,4))
    
    pc = 2;
    c = coeff(:,pc);
    c = reshape(c, 64, []); % channel x stim
    
    figure(123);clf
    imagesc(c); colorbar;
    xlabel('stim pulse')
    ylabel('probe channel')
    
    figure(123); clf;
    plot(mean(c,1))
    
    figure(123); clf;
    last10 = mean(c(:,90:100), 2);
    histogram(last10,100)

end
