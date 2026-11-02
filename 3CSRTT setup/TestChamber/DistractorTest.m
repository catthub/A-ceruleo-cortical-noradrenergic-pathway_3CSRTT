%% Distractor Test after Training

experimentFlag = true;
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
        cam.Preview
        start(T);   % start video recording
    end


    ino.stage = 9;


    %{
        ------------------
        | start training |
        ------------------
    %}

    ino.startLog = datestr(now, 'dd-mmm_HH-MM');
    fprintf('\n---------- Session Start ----------\n');
    fprintf('%d\n', ino.startLog);
    if ino.stage == 0
        fprintf('training Stage error')
    else
        session = true;
        past_trials = 0;
        sessionTimer = tic;
        ino.ticTimer(sessionTimer);
        while session
            %{
                trial parameters
            %}

            DistractorInterval = 0;     % 0: static distractor
            waitingTime = randi([50,70])/10;
            stimulusTime = 1;
            holdingTime = 5;
            rewardDelay = paras.water4ul;

            if ino.trial == 0
                ino.FreeWaterSupply(rewardDelay, 0);
                ino.trial = ino.trial + 1;
            end

            if ino.trial < 6
                ino.DistractorTrial = 0;
            else
                % ino.DistractorTrial = 0;
                ino.DistractorTrial = sign(randi(4) - 4) + 1;   % 20% chance
                if ino.DistractorTrial == 1
                    DistractorInterval = 0;
                    % DistractorInterval = randsample([1.1, 1.7, 2.3], 1);
                end
            end

            try
                ino.Training_and_DistractorTest(waitingTime, stimulusTime, holdingTime, rewardDelay, DistractorInterval);
            catch ref = ino.Refuge;
                clear ino
                pause(5)
                ino = eArduino_verCaL(arduino(paras.ino0,'Mega2560'));
                ino.Revival(ref);
                ino.PinConfiguration;
                clear ref
            end

            % summarize data
            fprintf('Subject: %d\nTrial: %d\n', mouseID, ino.trial);
            ino.CountActions;
            ino.CalcActionRatios;
            ino.Retract_parameters;

            ino.trial = ino.trial + 1;

            % Session end
            if toc(sessionTimer)  > paras.sessionCriteria
                session = false;
                experimentFlag = false;
                ino.Save_data(paras.dataPath, mouseID, experimentDayCount);
                fprintf('---------- Session End ----------\n');
                break;
            end
        end
    end

    t_log(end + 1, :) = {mouseID experimentDayCount datestr(now, 'dd-mmm_HH-MM') ino.session ino.stage 0};
    writetable(t_log, strcat(paras.trainingLogPath, '\', paras.trainingLogName));

    if paras.camera_switch
        stop(T);
        % cam.ClosePreview
        vfnam = strcat(paras.videoPath, '\', string(mouseID),'_day_', string(experimentDayCount), '_Session_',...
                        string(ino.session),'_',datestr(now, 'dd-mmm_HH-MM'), '_', cam.videoStatus, '.avi');
        SaveVideo(cam.VideoImg, vfnam, fps)
        fprintf('video saved!\n')
    end

end

appendPlexonBehavMap(mouseID, ino, pharm);

diary off

