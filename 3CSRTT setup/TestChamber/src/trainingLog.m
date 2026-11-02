function animalTrainingLog = trainingLog(mouseID, dirs)
    if isfile(fullfile(dirs.trainingLogPath, dirs.trainingLogName))
        animalTrainingLog = readtable(fullfile(dirs.trainingLogPath, dirs.trainingLogName));
    else
        animalTrainingLog = InitTrainingLog_mouse(mouseID, 'Save', 'T', 'Filenam', dirs.trainingLogName);
    end
    disp(animalTrainingLog)
end
