function chambparas = SetChamberPars(chamber, mouseID)

    chambparas.trainingLogName = sprintf('trainingLog_%d.txt', mouseID);
    chambparas.trainingLogPath = './TrainingLog';

    if chamber == 1
        chambparas.dataPath = './LogFile';
        chambparas.videoPath = './VideoLog';
        chambparas.sessionCriteria = 15 * 60;     % 15 min
        chambparas.sessionN = 10;     % maximum session per day
        chambparas.maxTrial = 400;
        chambparas.water6ul = 72/1000;
        chambparas.water5ul = 54/1000;
        chambparas.water4ul = 36/1000;
        chambparas.ino0 = 'COM6';     % arduino MEGA
        chambparas.ino1 = 'COM7';
        chambparas.ino2 = 'COM9';
        chambparas.ino3 = 'COM8';
        chambparas.camera_switch = 1;  %ON 1; OFF 0
        chambparas.webcamName = 5;
    else
        error('chamber not defined')
    end
end
