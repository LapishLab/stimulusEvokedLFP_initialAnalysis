function recording = loadRecording(rec_path)
    session = Session(rec_path);
    % Only look at the first record node for now (assume their will only be 1)
    node = session.recordNodes{1};
    % Only look at the first recording for now (assume their will only be 1)
    recording = node.recordings{1,1};
end