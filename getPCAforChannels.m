function goodChannels = getPCAforChannels(shapedData)
    d = mean(shapedData.samples, [3,4]);
    [coeff,score,latent,tsquared,explained,mu] = pca(d');

    %% plot PC score
    figure(101); clf
    nPCs = 5;
    tiledlayout(nPCs,1)
    for i=1:nPCs
        nexttile
        plot(score(:,i))
    end

    %% Show which probes encode which PCs
    figure(102); clf
    imagesc(coeff(:,1:nPCs))


    %% Cluster PCs
    PC_a = 1;
    PC_b = 3;
    figure(103); clf
    %histogram(coeff(:,pc)); 
    scatter(coeff(:,PC_a), coeff(:,PC_b))
    xlabel(sprintf('pc%i', PC_a'))
    ylabel(sprintf('pc%i', PC_b'))


    goodChannels = coeff(:,1) > 0;

end