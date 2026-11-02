function appendPlexonBehavMap(mouseID, ino, plexon)
% appendPlexonBehavMap
% Appends a key-value mapping to plexon_behav_map.yaml
%
% Example YAML line:
%   plexonSS_185: 123_SS4

    % Create value and key
    value = sprintf("%d_SS%d", mouseID, ino.session);
    key   = sprintf("plexonSS_%s", string(plexon));

    % YAML line
    yamlLine = key + ": " + value;

    % Output file
    yamlFile = "plexon_behav_map.yaml";

    % Open file in append mode
    fid = fopen(yamlFile, "a");
    if fid == -1
        error("Cannot open YAML file for writing: %s", yamlFile);
    end

    % Write line
    fprintf(fid, "%s\n", yamlLine);

    % Close file
    fclose(fid);
end
