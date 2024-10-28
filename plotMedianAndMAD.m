function [h, avg, err] = plotMedianAndMAD(x, ymat, lineProps)
    ymat = squeeze(ymat);
    avg = median(ymat,1);
    err = mad(ymat, 1, 1);

    if isempty(x)
        x = 1:length(avg);
    end
    h = shadedErrorBar(x, avg,err, 'lineProps',lineProps);
    h.edge(1).Visible = 'off';
    h.edge(2).Visible = 'off';
end