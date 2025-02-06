function data = downsampleData(data, downSampledRate)
    currentSampleRate = data.metadata.sampleRate / 1e3;
    downSampleFactor = round(currentSampleRate / downSampledRate);

    data.timestamps = data.timestamps(1:downSampleFactor:end);
    data.samples = decimate(data.samples, downSampleFactor);
    data.sampleNumbers = data.sampleNumbers(1:downSampleFactor:end);
    data.metadata.sampleRate = downSampledRate;
end