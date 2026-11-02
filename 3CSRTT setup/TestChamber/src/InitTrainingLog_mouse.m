function trainigLog = InitTrainingLog_mouse(mouseID, options)
    %{
        Output VariableNames
            miceID
            experiment_date
            real_date
            session
            stage: trainig stage
            result;
                0: in stage
                1: stege completed
    %}
    arguments
        mouseID (1,1) {mustBeNumeric}            % <-- scalar
        options.Save (1,1) string = 'F';
        options.Path = pwd;
        options.Filenam = [];
    end

    % Single entry (scalar mouseID)
    ex_date = -1;
    dates   = "initialCommit";
    session = 0;
    stage   = 0;
    result  = 0;

    trainigLog = table( ...
        mouseID, ex_date, dates, session, stage, result, ...
        'VariableNames', {'miceID','ex_date','date','session','stage','result'});

    % Optional save (keeps your 'T'/'F' string flag)
    if options.Save == "T"
        if isempty(options.Filenam)
            % default name: trainingLog_<YYYYMMDD>.txt
            stamp = datestr(today, 'yyyymmdd');
            fname = "trainingLog_" + stamp + ".txt";
            outpath = fullfile(string(options.Path), fname);
        else
            outpath = fullfile(string(options.Path), string(options.Filenam));
        end

        % Save as a text table
        writetable(trainigLog, outpath);

        fprintf('Create and Save trainingLog to:\n    %s\n', outpath);
    end
end
