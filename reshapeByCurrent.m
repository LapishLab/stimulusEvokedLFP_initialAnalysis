function data = reshapeByCurrent(data, currents)
    sz = size(data.samples);
    numCurrents = length(currents);
    pulsePerGroup = sz(3) / numCurrents;
    if pulsePerGroup ~= round(pulsePerGroup)
        error(['Number of ON events does not evenly divide by' ...
            ' the number of currents listed: ' ...
            '%i ON events detected, ' ...
            '%i currents listed'], sz(3), numCurrents);
    end
    data.dimensions = ["probe channels", "time", "pulses/group", "current amplitude"];
    data.samples = reshape(data.samples, sz(1),sz(2),pulsePerGroup,numCurrents);
end