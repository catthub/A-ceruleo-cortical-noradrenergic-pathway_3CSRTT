function [mouseID, chamber, plexon, selection] = UserInput()
    % Create modal UI
    fig = uifigure('Name','User Input','WindowStyle','modal','Position',[100 100 380 220]);

    gl = uigridlayout(fig,[5,2]);     % 4 rows for inputs, 1 for buttons
    gl.RowHeight = {30,30,30,30,'1x'};
    gl.ColumnWidth = {110,'1x'};

    % mouse ID (numeric)
    uilabel(gl,'Text','mouse ID');
    efMouse = uieditfield(gl,'numeric','Value',0,'Limits',[-Inf Inf],'ValueDisplayFormat', '%.f');

    % chamber (numeric)
    uilabel(gl,'Text','chamber');
    efChamber = uieditfield(gl,'numeric','Value',0,'Limits',[-Inf Inf],'ValueDisplayFormat', '%.f');

    % Plexon_ID (text)
    uilabel(gl,'Text','PlexonID');
    efPlexon = uieditfield(gl,'text','Value','drugs');

    % Selection (dropdown)
    uilabel(gl,'Text','Selection');
    dd = uidropdown(gl,'Items',{'Habituation','Training','DistractorTest'}, ...
                     'Value','Training');

    % Buttons
    btnPanel = uipanel(gl);
    btnPanel.Layout.Column = [1 2];
    btnPanel.Layout.Row = 5;
    bp = uigridlayout(btnPanel,[1,3]); bp.ColumnWidth = {'1x',90,90};

    uibutton(bp,'Text','Cancel', ...
        'ButtonPushedFcn',@(b,~) cancel());
    uibutton(bp,'Text','OK', ...
        'ButtonPushedFcn',@(b,~) ok());

    % Block until user acts
    uiwait(fig);

    % If cancelled, throw
    if ~isvalid(fig) || strcmp(getappdata(0,'user_inputs_status'),'cancel')
        if isvalid(fig), delete(fig); end
        error('User cancelled input dialog.');
    end

    % Read values
    mouseID   = efMouse.Value;
    chamber   = efChamber.Value;
    plexon    = efPlexon.Value;
    selection = dd.Value;

    if isvalid(fig), delete(fig); end

    % --- nested callbacks ---
    function ok()
        setappdata(0,'user_inputs_status','ok');
        uiresume(fig);
    end

    function cancel()
        setappdata(0,'user_inputs_status','cancel');
        uiresume(fig);
    end
end
