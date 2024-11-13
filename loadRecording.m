function recording = loadRecording(rec_path)
    session = Session(rec_path);
    
    numNodes = length(session.recordNodes);
    if numNodes>1
        names = strings(numNodes,1);
        for i=1:numNodes
            names(i) = session.recordNodes{i}.name;
        end
        
        fprintf('%s \n', strcat(string(1:numNodes)',":  ", names))
        choice = input('Which node to analyze? Enter number from above:  ');
        node = session.recordNodes{choice};
    else
        node = session.recordNodes{1};
    end
    

    numRecs = length(node.recordings);
    if numRecs>1
        names = strings(numRecs,1);
        for i=1:numRecs
            names(i) = node.recordings{i}.directory;
        end

        fprintf('%s \n', strcat(string(1:numRecs)',":  ", names))
        choice = input('Which recording to analyze? Enter number from above:  ');
        recording = node.recordings{choice};
    else
        recording = node.recordings{1};
    end
    
end