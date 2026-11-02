classdef eArduino_verCaL < handle
    %{
        ----------------------------
        | Controlling Test chamber |
        ----------------------------
    %}
    properties
        ino
        log = [];
        log_archives = {};
        Timer;
        parameter_summary = table();
        startLog ='';
        endLog = '';
        session = 0;
        stage = 0;
        trial = 0;
        DistractorTrial = 0;

        % behavioral parameters
        premature = 0;
        correct = 0;
        incorrect = 0;
        omission = 0;
        prematureR = 0;
        accuracyR = 0;
        omissionR = 0;

        % arduino pins
        HouseLight = ''
        % port 1
        NosePort = ''
        PortLight = ''
        Reward1 = ''
        % port 2
        NosePort2 = ''
        PortLight2 = ''
        Reward2 = ''
        % port3
        NosePort3 = ''
        PortLight3 = ''
        Reward3 = ''
        % distractor
        Distractor1 = ''
        Distractor2 = ''
        Distractor3 = ''

        % video port
        VideoON = ''

        % TTL port
        TTL1 = ''
    end

    methods
        function obj = eArduino_verCaL(arduino)
            obj.ino = arduino;
        end

        function init(obj)
            obj.log = [];
            obj.log_archives = {};
            obj.session = 0;
            obj.stage = 0;
            obj.trial = 0;
            obj.DistractorTrial = 0;

            % behavioral parameters
            obj.premature = 0;
            obj.correct = 0;
            obj.incorrect = 0;
            obj.omission = 0;
            obj.prematureR = 0;
            obj.accuracyR = 0;
            obj.omissionR = 0;

            obj.parameter_summary = table(obj.stage, obj.trial,...
                    obj.premature, obj.correct, obj.incorrect, obj.omission,...
                    obj.prematureR, obj.accuracyR, obj.omissionR,...
                    'VariableNames',{'stage', 'trial',...
                            'premature', 'correct', 'incorrect', 'omission',...
                            'prematureR', 'accuracyR', 'omissionR'});

            % arduino pins
            obj.HouseLight = 'D52';
            % port 1
            obj.NosePort = 'D24';
            obj.PortLight = 'D26';
            obj.Reward1 = 'D28';
            % port 2
            obj.NosePort2 = 'D34';
            obj.PortLight2 = 'D36';
            obj.Reward2 = 'D38';
            % port3
            obj.NosePort3 = 'D44';
            obj.PortLight3 = 'D46';
            obj.Reward3 = 'D48';
            % distractor
            obj.Distractor1 = 'D53';
            obj.Distractor2 = 'D51';
            obj.Distractor3 = 'D49';

            % video port
            obj.VideoON = 'D12';

            % TTL port
            obj.TTL1 = 'D5';
        end

        function PinConfiguration(obj)
            %{
                Set PinMode
            %}
            configurePin(obj.ino, obj.HouseLight,'DigitalOutput');
            % port1
            configurePin(obj.ino, obj.NosePort,'Pullup');
            configurePin(obj.ino, obj.PortLight,'DigitalOutput');
            configurePin(obj.ino, obj.Reward1,'DigitalOutput');
            % port2
            configurePin(obj.ino, obj.NosePort2,'Pullup');
            configurePin(obj.ino, obj.PortLight2,'DigitalOutput');
            configurePin(obj.ino, obj.Reward2,'DigitalOutput');
            % port3
            configurePin(obj.ino, obj.NosePort3,'Pullup');
            configurePin(obj.ino, obj.PortLight3,'DigitalOutput');
            configurePin(obj.ino, obj.Reward3,'DigitalOutput');
            % distractor
            configurePin(obj.ino, obj.Distractor1,'DigitalOutput');
            configurePin(obj.ino, obj.Distractor2,'DigitalOutput');
            configurePin(obj.ino, obj.Distractor3,'DigitalOutput');
            % video port
            configurePin(obj.ino, obj.VideoON, 'DigitalOutput');
            % TTL
            configurePin(obj.ino, obj.TTL1, 'DigitalOutput');
        end

        function LEDBlink(obj)
            %{
                test
            %}
            writeDigitalPin(obj.ino, obj.HouseLight, 1);
            pause(1);
            writeDigitalPin(obj.ino, obj.HouseLight, 0);
        end

        function CallLEDBlink(obj)
            %{
                test2
            %}
            testTime = tic;
            obj.LEDBlink();
            obj.TakeLog(toc(testTime),2);
        end

        function ref = Refuge(obj)
            %{
                in case unwanted Arduino disconnection    
            %}
            ref.log = obj.log;
            ref.log_archives = obj.log_archives;
            ref.Timer = obj.Timer;
            ref.startLog = obj.startLog;
            ref.endLog = obj.endLog;
            ref.session = obj.session;
            ref.stage = obj.stage;
            ref.trial = obj.trial;
            ref.DistractorTrial = obj.DistractorTrial;

            % behavioral parameters
            ref.premature = obj.premature;
            ref.correct = obj.correct;
            ref.incorrect = obj.incorrect;
            ref.omission = obj.omission;
            ref.prematureR = obj.prematureR;
            ref.accuracyR = obj.accuracyR;
            ref.omissionR = obj.omissionR;

            ref.parameter_summary = obj.parameter_summary;
            % arduino pins
            ref.HouseLight = obj.HouseLight;
            % port 1
            ref.NosePort = obj.NosePort;
            ref.PortLight = obj.PortLight;
            ref.Reward1 = obj.Reward1;
            % port 2
            ref.NosePort2 = obj.NosePort2;
            ref.PortLight2 = obj.PortLight2;
            ref.Reward2 = obj.Reward2;
            % port3
            ref.NosePort3 = obj.NosePort3;
            ref.PortLight3 = obj.PortLight3;
            ref.Reward3 = obj.Reward3;
            % Distractor
            ref.Distractor1 = obj.Distractor1;
            ref.Distractor2 = obj.Distractor2;
            ref.Distractor3 = obj.Distractor3;
            % video port
            ref.VideoON = obj.VideoON;
            % TTL port
            ref.TTL1 = obj.TTL1;
        end

        function Revival(obj, ref)
            %{
                in case unwanted Arduino disconnection    
            %}
            obj.log = ref.log;
            obj.log_archives = ref.log_archives;
            obj.startLog = ref.startLog;
            obj.endLog = ref.endLog;
            obj.session = ref.session;
            obj.stage = ref.stage;
            obj.trial = ref.trial;
            obj.DistractorTrial = ref.DistractorTrial;

            % behavioral parameters
            obj.premature = ref.premature;
            obj.correct = ref.correct;
            obj.incorrect = ref.incorrect;
            obj.omission = ref.omission;
            obj.prematureR = ref.prematureR;
            obj.accuracyR = ref.accuracyR;
            obj.omissionR = ref.omissionR;

            obj.parameter_summary = ref.parameter_summary;
            % arduino pins
            obj.HouseLight = ref.HouseLight;
            % port 1
            obj.NosePort = ref.NosePort;
            obj.PortLight = ref.PortLight;
            obj.Reward1 = ref.Reward1;
            % port 2
            obj.NosePort2 = ref.NosePort2;
            obj.PortLight2 = ref.PortLight2;
            obj.Reward2 = ref.Reward2;
            % port3
            obj.NosePort3 = ref.NosePort3;
            obj.PortLight3 = ref.PortLight3;
            obj.Reward3 = ref.Reward3;
            % Distractor1
            obj.Distractor1 = ref.Distractor1;
            obj.Distractor2 = ref.Distractor2;
            obj.Distractor3 = ref.Distractor3;
            % video port
            obj.VideoON = ref.VideoON;
        end


        %{
            -----------------------------------------
            % Record, save and clculation functions %
            -----------------------------------------
        %}
        function TakeLog(obj, time, action)
            %{
                --- Distractor Test ---
                199: distractor trial indicater
                200: distractor LED off
                201: distractor LED on
                300 + DistractorInterval

                ----- Response ------
                99: premature response
                100: correct response
                101: incorrect response
                102: omission

                --- Response log ---
                21: port1
                22: port2
                23: port3

                --- Trial control ---
                10: trial start
                11: waiting period
                12: stimulus period
                13: holding period
                14: time out
                15: trial end

                -- TTL --
                50: TTL ON
                51: TTL OFF

                -- Reward deliver --
                1: deliver
                0: consumption end

                -- Trial parameter --
                * # will be replaced by actual duration
                100#: waiting period duration (ex. 1004 -> 4s waiting duration)
                200#: Stimulus presentation duration (ex. 2010 -> 1.0 s stimulus presentation)
            %}
            updateLog = [obj.log; [obj.trial, time, action]];
            obj.log = updateLog;
        end

        function Clear_log(obj)
            obj.log = [];
        end

        function Clear_archives(obj)
            obj.log_archives = {};
        end

        function Clear_behavioralParameters(obj)
            obj.premature = 0;
            obj.correct = 0;
            obj.incorrect = 0;
            obj.omission = 0;
            obj.prematureR = 0;
            obj.accuracyR = 0;
            obj.omissionR = 0;
        end

        function Retract_parameters(obj)
            obj.parameter_summary(end + 1, :) = {obj.stage, obj.trial,...
                    obj.premature, obj.correct, obj.incorrect, obj.omission,...
                    obj.prematureR, obj.accuracyR, obj.omissionR};
            try
                disp(obj.parameter_summary([end - 1, end], :));
            catch
                disp(obj.parameter_summary);
            end
        end

        function Stage_transition(obj)
            obj.stage = obj.stage + 1;
            obj.trial = 1;
            obj.Clear_log;
            obj.Clear_behavioralParameters;
        end

        function CountActions(obj)
            obj.premature = sum(obj.log(:, 3) == 99);
            obj.correct = sum(obj.log(:, 3) == 100);
            obj.incorrect = sum(obj.log(:, 3) == 101);
            obj.omission = sum(obj.log(:, 3) == 102);
        end

        function CalcActionRatios(obj)
            %{
                prematureRatio: premature / all trials
                accuracy: correct / (correct + incorrect)
                omissionRatio: omission / (all trials - premature trials)
            %}
            obj.prematureR = obj.premature / max(obj.log(:, 1));
            if obj.correct == 0 && obj.incorrect == 0
                obj.accuracyR = 0;
            else
                obj.accuracyR = obj.correct / (obj.correct + obj.incorrect);
            end
            if obj.omission == 0
                obj.omissionR = 0;
            else
                obj.omissionR = obj.omission / (obj.correct + obj.incorrect + obj.omission);
            end
        end

        function Save_rawData(obj, f_path)
            f_nams = strcat(f_path, '_rawData.txt');
            writematrix(obj.log, f_nams);
        end

        function Save_behavioralParameters(obj, f_path)
            f_nams = strcat(f_path, '_behavioralParameters.txt');
            writetable(obj.parameter_summary, f_nams);
        end

        function Save_data(obj, filePath, subjectID, expDay)
            obj.endLog = datestr(now, 'dd-mmm_HH-MM');
            fileNam = strcat(string(subjectID),'_day_', string(expDay), '_Stage_', string(obj.stage),'_Session_',string(obj.session), '_', obj.startLog, '_', obj.endLog);

            f_path1 = strcat(filePath, '\rawData\', fileNam);
            f_path2 = strcat(filePath, '\', fileNam);
            obj.Save_rawData(f_path1);
            obj.Save_behavioralParameters(f_path2);
            fprintf('data saved!\n');
        end

        %{
            --------------------------------
            % experiment control functions %
            --------------------------------   
        %}
        function ticTimer(obj, timer)
            obj.Timer = timer;
        end

        function TTL_ON(obj)
            writeDigitalPin(obj.ino, obj.TTL1, 1);
        end

        function TTL_OFF(obj)
            writeDigitalPin(obj.ino, obj.TTL1, 0);
        end

        function TTL_pulse(obj)
            writeDigitalPin(obj.ino, obj.TTL1, 1);
            fprintf('TTL Pulse\n');
            pause(0.1)
            writeDigitalPin(obj.ino, obj.TTL1, 0);
        end

        function WaterON(obj, PIN)
            writeDigitalPin(obj.ino, PIN, 1);
        end

        function WaterOFF(obj, PIN)
            writeDigitalPin(obj.ino, PIN, 0);
        end

        function RewardCalibration(obj, delayTime, Count, rewardPin)
            fprintf('reward caliburation: ');
            for i = 1:Count
                lineLength = fprintf('%d', i);
                writeDigitalPin(obj.ino, rewardPin, 1);
                java.lang.Thread.sleep(delayTime * 1000)
                writeDigitalPin(obj.ino, rewardPin, 0);
                java.lang.Thread.sleep(30)
                fprintf(repmat('\b',1,lineLength))
            end
            fprintf('done\n');
        end

        function RewardFunc(obj, detected, delayTime, trialTime)
            if detected > 0
                if detected == 1
                    rewardPin = obj.Reward1;
                elseif detected == 2
                    rewardPin = obj.Reward2;
                elseif detected == 3
                    rewardPin = obj.Reward3;
                end

                fprintf('reward supply\n')
                obj.TakeLog(toc(trialTime), 1);

                writeDigitalPin(obj.ino, rewardPin, 1);
                java.lang.Thread.sleep(delayTime * 1000);
                writeDigitalPin(obj.ino, rewardPin, 0);

                fprintf('- water consuption\n')
                while obj.PortMonitor ~= 0
                    % water cnsumption
                end
                obj.TakeLog(toc(trialTime), 0);
                fprintf('- end water consuption\n')
            else
                % do nothing
            end
        end

        function detected = PortMonitor(obj)
            detected = 0;
            if readDigitalPin(obj.ino, obj.NosePort) == 0
                detected = 1;
            elseif readDigitalPin(obj.ino, obj.NosePort2) == 0
                detected = 2;
            elseif readDigitalPin(obj.ino, obj.NosePort3) == 0
                detected = 3;
            end
        end

        function Port_Check(obj)
            port1Check = 0;
            port2Check = 0;
            port3Check = 0;
            startTime = tic;
            while 1
                if readDigitalPin(obj.ino, obj.NosePort) == 1
                    port1Check = 1;
                end
                if readDigitalPin(obj.ino, obj.NosePort2) == 1
                    port2Check = 1;
                end
                if readDigitalPin(obj.ino, obj.NosePort3) == 1
                    port3Check = 1;
                end

                if toc(startTime) > 1
                    error('port debug error. \nport status: port1 %d, port2 %d, port3 %d',...
                        port1Check, port2Check, port3Check)
                end

                if port1Check + port2Check + port3Check == 3
                    fprintf('port check complete. All port IR LED and sensor works!\n')
                    break
                end
            end
        end

        function Port_Debug(obj)
            port1Check = 0;
            port2Check = 0;
            port3Check = 0;
            startTime = tic;
            while 1
                if readDigitalPin(obj.ino, obj.NosePort) == 1
                    port1Check = 1;
                end
                if readDigitalPin(obj.ino, obj.NosePort2) == 1
                    port2Check = 1;
                end
                if readDigitalPin(obj.ino, obj.NosePort3) == 1
                    port3Check = 1;
                end

                if toc(startTime) > 1
                    error('port debug error. \nport status: port1 %d, port2 %d, port3 %d',...
                        port1Check, port2Check, port3Check)
                end

                if port1Check + port2Check + port3Check == 3
                    break
                end
            end

            port1Check = 0;
            port2Check = 0;
            port3Check = 0;
            while 1
                if readDigitalPin(obj.ino, obj.NosePort) == 0
                    port1Check = 1;
                    writeDigitalPin(obj.ino, obj.PortLight, 0);
                else
                    writeDigitalPin(obj.ino, obj.PortLight, 1);
                end

                if readDigitalPin(obj.ino, obj.NosePort2) == 0
                    port2Check = 1;
                    writeDigitalPin(obj.ino, obj.PortLight2, 0);
                else
                    writeDigitalPin(obj.ino, obj.PortLight2, 1);
                end

                if readDigitalPin(obj.ino, obj.NosePort3) == 0
                    port3Check = 1;
                    writeDigitalPin(obj.ino, obj.PortLight3, 0);
                else
                    writeDigitalPin(obj.ino, obj.PortLight3, 1);
                end

                if port1Check + port2Check + port3Check == 3
                    writeDigitalPin(obj.ino, obj.PortLight, 0);
                    writeDigitalPin(obj.ino, obj.PortLight2, 0);
                    writeDigitalPin(obj.ino, obj.PortLight3, 0);
                    break
                end
            end
        end


        function StimulusON(obj, correctPort)
            if correctPort == 1
                writeDigitalPin(obj.ino, obj.PortLight, 1)
            elseif correctPort == 2
                writeDigitalPin(obj.ino, obj.PortLight2, 1)
            elseif correctPort == 3
                writeDigitalPin(obj.ino, obj.PortLight3, 1)
            end
        end

        function StimulusOFF(obj)
            writeDigitalPin(obj.ino, obj.PortLight, 0)
            writeDigitalPin(obj.ino, obj.PortLight2, 0)
            writeDigitalPin(obj.ino, obj.PortLight3, 0)
        end

        function StimulusALLON(obj)
            writeDigitalPin(obj.ino, obj.PortLight, 1)
            writeDigitalPin(obj.ino, obj.PortLight2, 1)
            writeDigitalPin(obj.ino, obj.PortLight3, 1)
        end

        function FreeWaterSupply(obj, supplyDuration, durationCriteria)
            %{
                habituation to Test chamber
                - free access to water for 15 min

                Stage 1 - 12
                - before 1st trial
                - 10-20 ul
            %}
            rewardConsumptionN = 0;

            trialDuration = tic;
            writeDigitalPin(obj.ino, obj.HouseLight, 1);
            obj.StimulusALLON;
            if durationCriteria > 0
                while toc(trialDuration) < durationCriteria
                    detected = obj.PortMonitor;
                    obj.RewardFunc(detected, supplyDuration, trialDuration)
                    if obj.stage > -1
                        if detected > 0
                            rewardConsumptionN = rewardConsumptionN + 1;
                        end
                        if rewardConsumptionN > 30   % change counts to fit criteria
                            break;
                        end
                    end
                    pause(1.0)
                end
            elseif durationCriteria == 0
                if obj.stage == 0
                    error('check stage and duration criteria')
                end
                while true
                    detected = obj.PortMonitor;
                    if obj.stage > 0
                        if detected > 0
                            toc(trialDuration)
                            obj.RewardFunc(detected, supplyDuration,trialDuration)  %% unstable 2026a
                            fprintf('reward\n')
                            toc(trialDuration)
                            fprintf('')
                            rewardConsumptionN = rewardConsumptionN + 1;
                        end
                        if rewardConsumptionN > 2   % change counts to fit criteria
                           break;
                        end
                        if toc(trialDuration) > 15
                            if rewardConsumptionN > 0
                                break;
                            end
                        end
                    end
                end
            end

            obj.StimulusOFF;
            writeDigitalPin(obj.ino, obj.HouseLight, 0);
            pause(4);   % ITI
        end


        function Training_and_DistractorTest(obj, waitingTime, stimulusTime, holdingTime, rewardDelay, DistractorInterval)
            % paremeter setup
            endTrial = 0;
            anyResponse = 0;
            timeOut = 0;
            LED_rotation = 0;
            correctPort = randi(3);
            trialTime = obj.Timer;

            trial_info = toc(trialTime);
            obj.TakeLog(trial_info,1000 + waitingTime);
            obj.TakeLog(trial_info, 2000 + stimulusTime * 10);
            if obj.DistractorTrial && obj.stage > 7
                distractor_switch = 1;
                distractorOff_switch = 1;
                obj.TakeLog(trial_info, 300 + DistractorInterval * 10);
                obj.TakeLog(trial_info, 199);
            end

            obj.TakeLog(toc(trialTime), 10);    % trial start
            obj.TakeLog(toc(trialTime), 50);    % TTL log
            obj.TTL_pulse;
            obj.TakeLog(toc(trialTime), 51);
            fprintf('trial %d start %.3f\n', obj.trial, toc(trialTime))

            writeDigitalPin(obj.ino, obj.HouseLight, 1);

            % -------------- %
            % waiting period %
            % -------------- %
            waitingPeriodStart = toc(trialTime);
            obj.TakeLog(waitingPeriodStart, 11);
            fprintf('waiting period start %.3f\n', waitingPeriodStart)

            while toc(trialTime) < waitingPeriodStart + waitingTime
                detected = obj.PortMonitor;
                if detected ~= 0
                    anyResponse = 1;
                    obj.TakeLog(toc(trialTime), 99);
                    obj.TakeLog(toc(trialTime), 20 + detected);
                    fprintf('premature response %.3f\n', toc(trialTime))
                    if obj.stage > 2
                        endTrial = 1;
                        timeOut = 1;
                        break
                    end
                end

                if obj.DistractorTrial && obj.stage > 7
                    if distractor_switch 
                        timeelapsed = toc(trialTime) - waitingPeriodStart;
                        if waitingTime - timeelapsed < 1
                            if DistractorInterval == 0
                                writeDigitalPin(obj.ino, obj.Distractor1, 1)
                                writeDigitalPin(obj.ino, obj.Distractor2, 1)
                                writeDigitalPin(obj.ino, obj.Distractor3, 1)
                            else
                                distractorTimeStamp = toc(trialTime);
                                writeDigitalPin(obj.ino, obj.Distractor1, 1)
                                distractorLED = 1;
                                LED_rotation = 1;
                            end
                            obj.TakeLog(toc(trialTime), 201);
                            fprintf('distractor ON %.3f\n', toc(trialTime))
                            distractor_switch = 0;
                        end
                    end
                    if LED_rotation == 1
                        distractor_timeelapsed = toc(trialTime) - distractorTimeStamp;
                        if distractor_timeelapsed >= DistractorInterval
                            if distractorLED + 1 == 2
                                writeDigitalPin(obj.ino, obj.Distractor1, 0)
                                writeDigitalPin(obj.ino, obj.Distractor2, 1)
                                distractorTimeStamp = toc(trialTime);
                                distractorLED = 2;
                            elseif distractorLED + 1 == 3
                                writeDigitalPin(obj.ino, obj.Distractor2, 0)
                                writeDigitalPin(obj.ino, obj.Distractor3, 1)
                                distractorTimeStamp = toc(trialTime);
                                distractorLED = 3;
                            else
                                writeDigitalPin(obj.ino, obj.Distractor3, 0)
                                writeDigitalPin(obj.ino, obj.Distractor1, 1)
                                distractorTimeStamp = toc(trialTime);
                                distractorLED = 1;
                            end
                        end
                    end
                end
            end

            % --------------- %
            % stimulus period %
            % --------------- %
            if ~endTrial
                stimulusPeriodStart = toc(trialTime);
                obj.StimulusON(correctPort);
                obj.TakeLog(stimulusPeriodStart, 12);
                fprintf('stimulus period start %.3f\n', stimulusPeriodStart)
                while toc(trialTime) < stimulusPeriodStart + stimulusTime
                    detected = obj.PortMonitor;
                    if detected == correctPort
                        obj.TakeLog(toc(trialTime), 100);
                        obj.TakeLog(toc(trialTime), 20 + detected);
                        fprintf('correct response %.3f\n', toc(trialTime))
                        obj.RewardFunc(detected, rewardDelay, trialTime);
                        endTrial = 1;
                        anyResponse = 1;
                        break
                    elseif detected > 0
                        anyResponse = 1;
                        obj.TakeLog(toc(trialTime), 101);
                        obj.TakeLog(toc(trialTime), 20 + detected);
                        fprintf('incorrect response %.3f\n', toc(trialTime))
                        if obj.stage > 1
                            endTrial = 1;
                            timeOut = 1;
                            break
                        end
                    end
                    if LED_rotation == 1
                        distractor_timeelapsed = toc(trialTime) - distractorTimeStamp;
                        if distractor_timeelapsed >= DistractorInterval
                            if distractorLED + 1 == 2
                                writeDigitalPin(obj.ino, obj.Distractor1, 0)
                                writeDigitalPin(obj.ino, obj.Distractor2, 1)
                                distractorTimeStamp = toc(trialTime);
                                distractorLED = 2;
                            elseif distractorLED + 1 == 3
                                writeDigitalPin(obj.ino, obj.Distractor2, 0)
                                writeDigitalPin(obj.ino, obj.Distractor3, 1)
                                distractorTimeStamp = toc(trialTime);
                                distractorLED = 3;
                            else
                                writeDigitalPin(obj.ino, obj.Distractor3, 0)
                                writeDigitalPin(obj.ino, obj.Distractor1, 1)
                                distractorTimeStamp = toc(trialTime);
                                distractorLED = 1;
                            end
                        end
                    end
                end
                obj.StimulusOFF
            end


            % -------------- %
            % holding period %
            % -------------- %
            if ~endTrial
                holdingPeriodStart = toc(trialTime);
                obj.TakeLog(holdingPeriodStart, 13);
                fprintf('holding period start %.3f\n', holdingPeriodStart)
                while toc(trialTime) < holdingPeriodStart + holdingTime
                    detected = obj.PortMonitor;
                    if detected == correctPort
                        obj.TakeLog(toc(trialTime), 100);
                        obj.TakeLog(toc(trialTime), 20 + detected);
                        fprintf('correct response %.3f\n', toc(trialTime))
                        obj.RewardFunc(detected, rewardDelay, trialTime);
                        endTrial = 1;
                        anyResponse = 1;
                        break
                    elseif detected > 0
                        anyResponse = 1;
                        obj.TakeLog(toc(trialTime), 101);
                        obj.TakeLog(toc(trialTime), 20 + detected);
                        fprintf('incorrect response %.3f\n', toc(trialTime))
                        if obj.stage > 1
                            endTrial = 1;
                            timeOut = 1;
                            break
                        end
                    end
                    if LED_rotation == 1
                        distractor_timeelapsed = toc(trialTime) - distractorTimeStamp;
                        if distractor_timeelapsed >= DistractorInterval
                            if distractorLED + 1 == 2
                                writeDigitalPin(obj.ino, obj.Distractor1, 0)
                                writeDigitalPin(obj.ino, obj.Distractor2, 1)
                                distractorTimeStamp = toc(trialTime);
                                distractorLED = 2;
                            elseif distractorLED + 1 == 3
                                writeDigitalPin(obj.ino, obj.Distractor2, 0)
                                writeDigitalPin(obj.ino, obj.Distractor3, 1)
                                distractorTimeStamp = toc(trialTime);
                                distractorLED = 3;
                            else
                                writeDigitalPin(obj.ino, obj.Distractor3, 0)
                                writeDigitalPin(obj.ino, obj.Distractor1, 1)
                                distractorTimeStamp = toc(trialTime);
                                distractorLED = 1;
                            end
                        end
                    end
                    if obj.DistractorTrial && obj.stage > 7
                        if distractorOff_switch && toc(trialTime) > holdingPeriodStart + 1
                            distractorOff_switch = 0;
                            writeDigitalPin(obj.ino, obj.Distractor1, 0)
                            writeDigitalPin(obj.ino, obj.Distractor2, 0)
                            writeDigitalPin(obj.ino, obj.Distractor3, 0)
                            obj.TakeLog(toc(trialTime), 200);
                            fprintf('distractor OFF %.3f\n', toc(trialTime))
                            LED_rotation = 0;
                        end
                    end
                end
            end

            if ~anyResponse
                obj.TakeLog(toc(trialTime), 102); % omission report
                fprintf('omission %.3f\n', toc(trialTime))
                endTrial = 1;
                timeOut = 1;
            end

            if endTrial
                writeDigitalPin(obj.ino, obj.Distractor1, 0);
                writeDigitalPin(obj.ino, obj.Distractor2, 0);
                writeDigitalPin(obj.ino, obj.Distractor3, 0);
                writeDigitalPin(obj.ino, obj.HouseLight, 0);
                if obj.stage > 1 && timeOut
                    obj.TakeLog(toc(trialTime), 14);  % time out report
                    fprintf('time out %.3f\n', toc(trialTime))
                    pause(5);
                end
                obj.TakeLog(toc(trialTime), 15);  % trial end
                fprintf('trial end %.3f\n', toc(trialTime))
                pause(4);   % ITI
            end
        end
    end
end
