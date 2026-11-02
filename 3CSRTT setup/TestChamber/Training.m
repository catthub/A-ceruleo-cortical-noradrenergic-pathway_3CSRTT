%% daily training routines after habituation
% StartTime = datetime('now');
experimentFlag = true;
experimentCount = 0;
diary(strcat('./LogFile/commandLog/',datestr(now, 'dd-mmm-HH-MM'),...
        '_chamber',num2str(chamber), '_mouse', num2str(mouseID),'_commexperimentCounterand-log.txt'))


while experimentFlag
    %{
        ----------------------------
        | session parameter config |
        ----------------------------
    %}
    if paras.camera_switch
        cam.initVideo
        % cam.Preview
        start(T);   % start video recording
    end


    if t_log.result(end) > 0
        % 1: completed stage, move on to next
        ino.stage = t_log.stage(end) + 1;
    else
        % 0: not completed, stick on it
        ino.stage = t_log.stage(end);
    end


    %{
        ------------------
        | start training |
        ------------------
    %}

    ino.startLog = datestr(now, 'dd-mmm_HH-MM');
    fprintf('---------- Session Start ----------');
    fprintf('%s\n', ino.startLog);
    if ino.stage == 0
        rewardDelay= paras.water6ul;
        sessionTime = paras.sessionCriteria;

        try
            ino.FreeWaterSupply(rewardDelay, sessionTime);
        catch
            ref = ino.Refuge;
            clear ino
            ino = eArduino_verCaL(arduino(paras.ino0,'Mega2560'));
            ino.Revival(ref);
            ino.PinConfiguration;
            clear ref
        end

    else
        session = true;
        past_trials = 0;
        sessionTimer = tic;
        ino.ticTimer(sessionTimer);
        while session
            %{
                trial parameters
            %}
            DistractorInterval = 0;
            if ino.stage == 1
                waitingTime = 5;
                stimulusTime = 30;
                holdingTime = 30;
                rewardDelay = paras.water6ul;
            elseif ino.stage == 2
                waitingTime = 5;
                stimulusTime = 20;
                holdingTime = 20;
                rewardDelay = paras.water5ul;
            elseif ino.stage == 3
                waitingTime = randi([50,70])/10;
                stimulusTime = 10;
                holdingTime = 10;
                rewardDelay = paras.water4ul;
            elseif ino.stage == 4
                waitingTime = randi([50,70])/10;
                stimulusTime = 5;
                holdingTime = 5;
                rewardDelay = paras.water4ul;
            elseif ino.stage == 5
                waitingTime = randi([50,70])/10;
                stimulusTime = 2.5;
                holdingTime = 5;
                rewardDelay = paras.water4ul;
            elseif ino.stage == 6
                waitingTime = randi([50,70])/10;
                stimulusTime = 1.25;
                holdingTime = 5;
                rewardDelay = paras.water4ul;
            elseif ino.stage == 7
                waitingTime = randi([50,70])/10;
                stimulusTime = 1;
                holdingTime = 5;
                rewardDelay = paras.water4ul;
            elseif ino.stage > 7
                waitingTime = randi([50,70])/10;
                stimulusTime = 1;
                holdingTime = 5;
                rewardDelay = paras.water4ul;
                ino.stage = 8;
                if ino.trial < 6
                    ino.DistractorTrial = 0;
                else
                    ino.DistractorTrial = 0;
                end
            end


            if ino.trial == 0
                ino.FreeWaterSupply(rewardDelay, 0);
                ino.trial = ino.trial + 1;
            end

            try
                ino.Training_and_DistractorTest(waitingTime, stimulusTime, holdingTime, rewardDelay, DistractorInterval);
            catch ref = ino.Refuge;
                clear ino
                pause(5)
                ino = eArduino_verCaL(arduino(paras.ino0,'Mega2560'));
                ino.Revival(ref);
                % ino.PinConfiguration
                clear ref
            end

            % summarize data
            fprintf('Subject: %d\nTrial: %d\n', mouseID, ino.trial);
            ino.CountActions;
            ino.CalcActionRatios;
            ino.Retract_parameters;

            ino.trial = ino.trial + 1;

            %{
                stege update and save data
            %}
            if ino.stage == 1 && ino.correct > 29
                t_log(end + 1, :) = {mouseID experimentDayCount datestr(now, 'dd-mmm_HH-MM') ino.session ino.stage 1};
                ino.Save_data(paras.dataPath, mouseID, experimentDayCount);
                past_trials = ino.trial;
                ino.Stage_transition;

            elseif ino.stage == 2 && ino.correct > 49
                t_log(end + 1, :) = {mouseID experimentDayCount datestr(now, 'dd-mmm_HH-MM') ino.session ino.stage 1};
                ino.Save_data(paras.dataPath, mouseID, experimentDayCount);
                past_trials = ino.trial;
                ino.Stage_transition;

            elseif ino.stage == 3 && ino.correct > 49 && ino.accuracyR > 0.8
                t_log(end + 1, :) = {mouseID experimentDayCount datestr(now, 'dd-mmm_HH-MM') ino.session ino.stage 1};
                ino.Save_data(paras.dataPath, mouseID, experimentDayCount);
                past_trials = ino.trial;
                ino.Stage_transition;

            elseif ino.stage > 3 && ino.stage < 8 ... 
                    && ino.correct > 49 && ino.accuracyR > 0.8 && ino.omissionR < 0.2
                t_log(end + 1, :) = {mouseID experimentDayCount datestr(now, 'dd-mmm_HH-MM') ino.session ino.stage 1};
                ino.Save_data(paras.dataPath, mouseID, experimentDayCount);
                past_trials = ino.trial;
                ino.Stage_transition;

            elseif toc(sessionTimer)  > paras.sessionCriteria || ino.trial + past_trials > paras.maxTrial
                session = false;
                if ino.stage == 8 && ino.correct > 49 && ino.accuracyR > 0.8 && ino.omissionR < 0.2
                    t_log(end + 1, :) = {mouseID experimentDayCount datestr(now, 'dd-mmm_HH-MM') ino.session ino.stage 1};
                else
                    t_log(end + 1, :) = {mouseID experimentDayCount datestr(now, 'dd-mmm_HH-MM') ino.session ino.stage 0};
                end
                ino.Save_data(paras.dataPath, mouseID, experimentDayCount);
                break;
            end
        end
    end
    writetable(t_log, strcat(paras.trainingLogPath, '\', paras.trainingLogName));
    fprintf('---------- Session End ----------');
    if paras.camera_switch
        stop(T);
        % cam.ClosePreview
        vfnam = strcat(paras.videoPath, '\', string(mouseID),'_day_', string(experimentDayCount), '_Session_',...
                        string(ino.session),'_',datestr(now, 'dd-mmm_HH-MM'), '_', cam.videoStatus, '.avi');
        SaveVideo(cam.VideoImg, vfnam, fps)
        fprintf('video saved!\n')
    end
    experimentCount = experimentCount + 1;
    ino.session = ino.session + 1;
    % ino.Clear_behavioralParameters;
    if experimentCount == sessionCriteria
        experimentFlag = false;
    end

end

diary off
