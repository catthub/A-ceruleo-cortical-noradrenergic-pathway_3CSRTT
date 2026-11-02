% run Debugs one by one
chamber = 1;
mouseID = 999;
paras = SetChamberPars(chamber, mouseID);

camera_switch = 1;
if camera_switch
    cam = eWebcam(webcam(paras.webcamName));
    % cam.Preview
end
if camera_switch
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
if camera_switch
    cam.initVideo
    cam.Preview
end

%{
    ---------------------
    | 1. arduino set up |
    ---------------------
%}

%-- initialize chamber --%
ino = eArduino_verCaL(arduino(paras.ino0,'Mega2560', "Trace", false));
ino.init
ino.PinConfiguration
ino.Port_Check      % use "Trace" true if needed

% tunnel check
try
    % connection check
    rfid = eRFID(serialport(HyperPar.ino1, 9600), serialport(HyperPar.ino2, 9600), serialport(HyperPar.ino3, 9600));
    pause(1)
catch ME
    warning(ME.message)
end


%-- Debugs --%
ino.Port_Debug
ino.WaterON(ino.Reward1);
ino.WaterON(ino.Reward2);
ino.WaterON(ino.Reward3);
pause(1);
ino.WaterOFF(ino.Reward1);
ino.WaterOFF(ino.Reward2);
ino.WaterOFF(ino.Reward3);
% ino.RewardCalibration(36/1000, 1000, ino.Reward1);
writeDigitalPin(ino.ino, ino.HouseLight, 1)
writeDigitalPin(ino.ino, ino.Distractor1, 1)
writeDigitalPin(ino.ino, ino.Distractor2, 1)
writeDigitalPin(ino.ino, ino.Distractor3, 1)
ino.StimulusALLON()

writeDigitalPin(ino.ino, ino.HouseLight, 0)
writeDigitalPin(ino.ino, ino.Distractor1, 0)
writeDigitalPin(ino.ino, ino.Distractor2, 0)
writeDigitalPin(ino.ino, ino.Distractor3, 0)
ino.StimulusOFF()

ino.TTL_ON()
ino.TTL_OFF()

