function dict = InitDict(miceID, RFID, options)
    arguments
        miceID (1, :)
        RFID (1, :) cell
        options.Save (1,1) string = 'F';
        options.Path = pwd;
    end

    if size(miceID, 2) ~= size(RFID, 2)
        error('size mismatch error')
    end
    
    miceID(1, end + 1) = -999;
    RFID{1, end + 1} = 'DummyID';
    dict = containers.Map(RFID, miceID);

    if options.Save == 'T'
        dictTable = table(miceID', RFID', ...
            'VariableNames', {'miceID', 'RFID'});

        writetable(dictTable, ...
            strcat(options.Path, '\', 'Mice-RFID', string(today('datetime')), '.txt'));
        fprintf('Save table to %s\n', options.Path);
    end
end