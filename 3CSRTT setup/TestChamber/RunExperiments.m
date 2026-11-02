[mouseID, chamber, pharm, selection] = UserInput();
paras = SetChamberPars(chamber, mouseID);

t_log = trainingLog(mouseID, paras);
experimentDayCount = max(t_log.ex_date) + 1;


%-- initialize chamber --%
ino = eArduino_verCaL(arduino(paras.ino0,'Mega2560'));
ino.init
ino.PinConfiguration
ino.Port_Check
ino.session = max(t_log.session) + 1;

%-- camera set up --%
if paras.camera_switch
    cam = eWebcam(webcam(paras.webcamName));
%     cam.Preview
    fps = 5;
    T = timer('Period', 1/fps,... %period
            'ExecutionMode','fixedRate',... %{singleShot,fixedRate,fixedSpacing,fixedDelay}
            'BusyMode','drop',... %{drop, error, queue}
            'TasksToExecute',inf,...
            'StartDelay',0,...
            'TimerFcn',@(varargin)cam.TakePhoto,...
            'StartFcn',[],...
            'StopFcn',[],...
            'ErrorFcn',@(varargin)cam.ErrorReport);
end


% ask user to proceed
msg = sprintf('mouse: %d\nchamber: %d\nexperiment: %s', mouseID, chamber, selection);
uiwait(msgbox(msg, 'Start Experiment'));



if strcmp(selection, 'Habituation')
    % Free water access from all port
    sessionTime = 60 * 10;   % 60 * 15;  % 15 min
    run('./Habituation.m')
end



if strcmp(selection, 'Training')
    sessino_duration = 15 * 60;    % unit: sec
    sessionCriteria = 4;
    paras.sessionCriteria = sessino_duration;
    run('./Training.m')
end



if strcmp(selection, 'DistractorTest')
    data_path = './LogFile/distractorTest';
    paras.dataPath = data_path;
    sessino_duration = 30 * 60;    % unit: sec
    paras.sessionCriteria = sessino_duration;
    run('./DistractorTest.m')
end

