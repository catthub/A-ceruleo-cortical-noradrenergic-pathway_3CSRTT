%% habituation to test chamber (Day1-2)
%{
    - Free water access from all ports
    - Set sessionTime to run Overnight habituation
    - Gates are recommended to be removed manually
%}

diary(strcat('./LogFile/commandLog/',datestr(now, 'dd-mmm-HH-MM'),...
        '_animal',num2str(mouseID),'_command-log.txt'))

rewardDelay= paras.water6ul;

habituationTime = tic;
while toc(habituationTime) < sessionTime
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
end

t_log(end + 1, :) = {mouseID experimentDayCount datestr(now, 'dd-mmm_HH-MM') 0 ino.stage 1};
writetable(t_log, strcat(paras.trainingLogPath, '\', paras.trainingLogName));


diary off


