function data = downsampleData(data, downSampledRate)
    currentSampleRate = data.metadata.sampleRate / 1e3;
    downSampleFactor = round(currentSampleRate / downSampledRate);

    data.timestamps = data.timestamps(1:downSampleFactor:end);
    data.samples = data.samples(:, 1:downSampleFactor:end);
    data.sampleNumbers = data.sampleNumbers(1:downSampleFactor:end);
    data.metadata.sampleRate = downSampledRate;
end