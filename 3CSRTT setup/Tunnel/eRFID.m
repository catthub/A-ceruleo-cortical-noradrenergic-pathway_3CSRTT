classdef eRFID < handle
    properties
        ino1
        ino2
        ino3
        SerialLog1 = []
        SerialLog2 = []
        SerialLog3 = []
    end

    methods
        function obj = eRFID(ino1, ino2, ino3)
            obj.ino1 = ino1;
            obj.ino2 = ino2;
            obj.ino3 = ino3;
        end
        %{
            -----------------------
            % Servo motor control %
            -----------------------    
        %}

        function OpenGate1(obj)
            writeline(obj.ino2, '1');
        end

        function CloseGate1(obj)
            writeline(obj.ino2, '2');
        end

        function OpenGate2(obj)
            writeline(obj.ino2, '3');
        end

        function CloseGate2(obj)
            writeline(obj.ino2, '4');
        end

        function AllOpen(obj)
            writeline(obj.ino2, 'A');
        end

        function ResetGatePosition(obj)
            writeline(obj.ino2, 'E');
        end

        %{
            ----------------------------------
            % Serial communication functions %
            ----------------------------------
        %}
        function RFIDDebug(obj)
            obj.OnRFID;

            configureCallback(obj.ino1, "terminator",...
                @(varargin)fprintf('RFID1_%s\n', strtrim(readline(obj.ino1))))
            configureCallback(obj.ino2, "terminator",...
                @(varargin)fprintf('RFID2_%s\n', strtrim(readline(obj.ino2))))
            configureCallback(obj.ino3, "terminator",...
                @(varargin)fprintf('RFID3_%s\n', strtrim(readline(obj.ino3))))
        end

        function TakeLog1(obj)
            serialOutput = strtrim(readline(obj.ino1));
            obj.SerialLog1 = [obj.SerialLog1; serialOutput];
            % disp(serialOutput);
        end

        function TakeLog2(obj)
            serialOutput = strtrim(readline(obj.ino2));
            obj.SerialLog2 = [obj.SerialLog2; serialOutput];
            % disp(serialOutput);
        end

        function TakeLog3(obj)
            serialOutput = strtrim(readline(obj.ino3));
            obj.SerialLog3 = [obj.SerialLog3; serialOutput];
            % disp(serialOutput);
        end

        function SetCallBack1(obj)
            writeline(obj.ino1, 'O');
            configureCallback(obj.ino1, "terminator", @(varargin)obj.TakeLog1)
        end

        function OffCallBack1(obj)
            writeline(obj.ino1, 'C');
            configureCallback(obj.ino1, "off")
        end

        function SetCallBack2(obj)
            writeline(obj.ino2, 'O');
            configureCallback(obj.ino2, "terminator", @(varargin)obj.TakeLog2)
        end

        function OffCallBack2(obj)
            writeline(obj.ino2, 'C');
            configureCallback(obj.ino2, "off")
        end

        function SetCallBack3(obj)
            writeline(obj.ino3, 'O');
            configureCallback(obj.ino3, "terminator", @(varargin)obj.TakeLog3)
        end

        function OffCallBack3(obj)
            writeline(obj.ino3, 'C');
            configureCallback(obj.ino3, "off")
        end

        function ClearLog1(obj)
            obj.SerialLog1 =[];
        end

        function ClearLog2(obj)
            obj.SerialLog2 =[];
        end

        function ClearLog3(obj)
            obj.SerialLog3 =[];
        end

        function ClearAllLog(obj)
            obj.ClearLog1
            obj.ClearLog2
            obj.ClearLog3
        end
        %{
            ------------------
            % Sorting system %
            ------------------
        %}

        function OnRFID(obj)
            obj.SetCallBack1
            obj.SetCallBack2
            obj.SetCallBack3
        end

        function OffRFID(obj)
            obj.OffCallBack1
            obj.OffCallBack2
            obj.OffCallBack3
        end

        function flag = GoToTestChamber(obj)
            %{
                ---------------------- STEPS ----------------------
                0. open door1
                1. RFID1 activated
                    if detect1 == mouse_a
                        pass
                2. RFID2 activated
                    a. open door2 and close door1 
                       if RFID1 detect nobody except mouse_a
                    b. close door1 if RFID1 detect somebody else
                        i. wait for 30sec to see how many are there
                            if: there is one ->  open door2
                            else: open door 1 and retern to step1
                3. RFID3 activated
                    close door2
                    go to experiment!
            %}
            obj.ClearAllLog

            % STEP 0
            flag = false;
            pass1 = [];

            obj.SetCallBack1
            obj.OpenGate1
            pause(0.5)
            %pause(1)

            % STEP 1
            while isempty(obj.SerialLog1) < 1
                if isempty(pass1)
                    pass1 = obj.SerialLog1(end);
                    obj.SetCallBack2
                    while isempty(obj.SerialLog2) < 1
                        obj.ClearLog2
                        fprintf('clear ID in Log2')
                    end
                end
                pause(0.005)

                % STEP 2
                if isempty(obj.SerialLog2) < 1
                    obj.CloseGate1
                    follow = obj.SerialLog1(end);
                    fprintf('Animnal detcted in tunnel. Close Gate1\n');
                    pass2 = obj.SerialLog2(end);
                    if follow == pass2 % No followers
                        flag = true;
                        fprintf('Single mouse detection. Go next\n');
                        break
                    else
                        fprintf('multiple mice detected.\n');
                        flag = false;
                        % closetimer1 = tic;
                        % while toc(closetimer1) < 30
                        %     pause(0.05)
                        %     % fprintf('time elapsed ... %d\n', toc(closetimer1));
                        %     % nothing
                        % end

                        % if size(unique(obj.SerialLog2), 1) == 1
                        %     fprintf('mice isolated, go next\n')
                        %     flag = true;
                        %     break
                        % else
                        %     obj.ClearLog1
                        %     obj.ClearLog2
                        %     obj.OffRFID
                        fprintf('Open Gate1 and let mice out\n');
                        Opentimer = tic;
                        obj.OpenGate1
                        pass2NotHomeFlag = true;
                        while pass2NotHomeFlag
                            someoneGotHome = obj.SerialLog1(end);
                            pause(0.5)
                            if someoneGotHome == pass2
                                obj.CloseGate1
                                fprintf('pass2 get home. Restart procedure.\n');
                                pass2NotHomeFlag = false;
                                obj.OffRFID
                                pause(10)
                                fprintf('Gate1 reopen\n');
                                break
                            end
                            if toc(Opentimer) > 60 * 3
                                obj.CloseGate1
                                fprintf('Timer count 3 min. Next step.\n');
                                pass2NotHomeFlag = false;
                                obj.OffRFID
                                pause(10)
                                fprintf('Gate1 reopen\n');
                                break
                            end
                        end
                        break
                        % end
                    end
                end
            end

            % STEP 3
            if flag
                obj.OffRFID
                obj.SetCallBack3
                obj.ClearLog3

                pause(0.5);
                obj.OpenGate2
                closetimer2 = tic;
                disp('Open Gate2')
                pause(0.5);
                while isempty(obj.SerialLog3)
                    obj.OpenGate2
                    pause(0.1)
                    % waiting for animal to pass tha door
                    if toc(closetimer2) > 10 * 60   % waiting buffer
                        % avoid to stack in there
                        % in case if animal don't move or no animal is there
                        flag = false;
                        fprintf('Animal stay tunnel. Close Gate2.\nSuggestion: waiting buffer may too short or habituation needed\n')
                        break;
                    end
                end
                obj.CloseGate2
                fprintf('Animal get in the chamber. Close gate2\n')
                % obj.OffCallBack3
            end
        end

        function flag = ComeBack(obj, dictionary)
            %{
              same operation to GotoTestChamber function
            %}
            obj.ClearAllLog

            % STEP 0
            flag = false;
            pass1 = [];

            obj.SetCallBack3
            obj.OpenGate2
            pause(0.5)
            %pause(1)

            % STEP 1
            while isempty(obj.SerialLog3) < 1
                if isempty(pass1)
                    pass1 = obj.SerialLog3(end);
                    obj.SetCallBack2
                    while isempty(obj.SerialLog2) < 1
                        obj.ClearLog2
                        fprintf('clear ID in Log2')
                    end
                end
                pause(0.005)

                % STEP 2
                if isempty(obj.SerialLog2) < 1
                    obj.CloseGate2
                    follow = obj.SerialLog3(end);
                    fprintf('Animnal detcted in tunnel. Close Gate2\n');
                    pass2 = obj.SerialLog2(end);
                    if follow == pass2 % No followers
                        flag = true;
                        fprintf('Single mouse detection. Go next\n');
                        break
                    else
                        fprintf('multiple mice detected.\n');
                        flag = false;
                        fprintf('Open Gate2 and let mice back\n');
                        obj.OpenGate2
                        pass2NotBackFlag = true;
                        while pass2NotBackFlag
                            someoneGotBack = obj.SerialLog3(end);
                            pause(0.1)
                            if someoneGotBack == pass2
                                obj.CloseGate2
                                fprintf('pass2 get back. Restart procedure.\n');
                                pass2NotBackFlag = false;
                                obj.OffRFID
                                pause(10)
                                fprintf('Gate3 reopen\n');
                                break
                            end
                        end
                        break
                    end
                end
            end

            % STEP 3
            if flag
                obj.OffRFID
                obj.SetCallBack1
                obj.ClearLog1

                pause(0.5);
                obj.OpenGate1
                % closetimer2 = tic;
                disp('Open Gate1')
                pause(0.5);
                animalNotReturnFlag = true;
                while animalNotReturnFlag
                    obj.OpenGate1
                    pause(0.1)
                    if isempty(obj.SerialLog1) < 1
                      log1Animal = obj.SerialLog1(end);
                      if log1Animal == pass2
                        break
                      end
                    end
                end
                obj.CloseGate1
                fprintf('Detected at Sensoer1: %d\n', dictionary(append('RFID', log1Animal)));
                fprintf('Animal get in the chamber. Close gate1\n')
            end
        end


        % function [flag, roop] = ReturnFromTestChamber(obj, dictionary, subject, roop)
        %     %{
        %         ------ STEPS ------
        %         0. Open door2
        %         1. RFID2 activated
        %             close door2
        %             open door1 

        %     %}
        %     flag = false;
        %     flag2 = true;
        %     next = false;
        %     pause(0.1)

        %     % STEP 1
        %     if isempty(obj.SerialLog2) == 0
        %         pass1 = obj.SerialLog2(end);
        %         try
        %             fprintf('pass1 detected in sensor2: %d\n', dictionary(append('RFID', pass1)));
        %         catch
        %             fprintf('pass1 sensor erorr. RFID: %d\n', pass1);
        %             pass1 = obj.SerialLog2(end);
        %             fprintf('pass1 detected in sensor2: %d\n', dictionary(append('RFID', pass1)));
        %         end
        %         obj.CloseGate2
        %         fprintf('Close Gate2\n');
        %         pause(0.1)

        %         if dictionary(append('RFID', pass1)) == subject
        %             if  size(unique(obj.SerialLog3), 1) < 2
        %                 % single mice
        %             else
        %                 % multiple mice
        %                 N = size(unique(obj.SerialLog3), 1);
        %                 fprintf('multiple mice(%d) entry detected in sensor3\n', N);
        %                 flag2 = false;
        %                 roop = true;
        %             end
        %         else
        %             % multiple mice
        %             if roop
        %                 if size(unique(obj.SerialLog3), 1) < 2
        %                     flag2 = true;
        %                     fprintf('let second mice out\n');
        %                 else
        %                     flag2 = false;
        %                     fprintf('mulitiple mice in chamber\n');
        %                 end
        %             else
        %                 roop = true;
        %                 flag2 = false;
        %                 fprintf('multiple mice entry detected in sensor2\n');
        %             end
        %         end

        %         obj.SetCallBack1
        %         obj.OpenGate1
        %         fprintf('Open Gate1\n');
        %         pause(1)
        %         obj.OffCallBack2
        %         next = true;
        %     end

        %     while next
        %         while isempty(obj.SerialLog1)
        %             % waitinig for some mice passing thorugh sensor 1
        %             pause(0.005);
        %         end
        %         pass2 = obj.SerialLog1(end);
        %         fprintf('pass2 detected: %d\n', dictionary(append('RFID', pass2)));
        %         if pass1 == pass2
        %             try
        %                 fprintf('welcome home %d\n', dictionary(append('RFID', pass1)))
        %             catch
        %                 fprintf('welcome home %s\n', pass1)
        %             end
        %             flag = true;
        %             obj.CloseGate1
        %             fprintf('Animal passed. Close Gate1\n');
        %             pause(1)
        %             break;
        %         else
        %             fprintf('multiple mice in tunnel: pass1 %d, pass2 %d\n',...
        %                 dictionary(append('RFID', pass1)), dictionary(append('RFID', pass2)))
        %             obj.ClearLog1
        %         end
        %     end
        %     if flag2

        %     else
        %         flag = false;
        %         obj.OpenGate2
        %         obj.ClearLog3
        %         obj.ClearLog2
        %         fprintf('Reopen Gate2 to pass next animal\n');
        %         obj.OpenGate2
        %         obj.SetCallBack2
        %         % pause(0.3)
        %     end
        % end

        function SortingToTestChamber(obj)
            flag = 0;
            fprintf('Open Gate1 to entry\n');
            while ~flag
                flag = obj.GoToTestChamber;
            end
        end

        function ReturnHome(obj,dictionary)
            flag = 0;
            fprintf('Open Gate2 to entry\n');
            while ~flag
                flag = obj.ComeBack(dictionary);
            end
        end

        % function ToHomeCage(obj, dictionary, subject)
        %     flag = 0;

        %     obj.ClearAllLog
        %     obj.SetCallBack3
        %     obj.SetCallBack2
        %     obj.OpenGate2
        %     fprintf('Open Gate2\n');
        %     pause(0.5)
        %     roop = false;

        %     while ~flag
        %         [flag, roop]  = obj.ReturnFromTestChamber(dictionary, subject, roop);
        %     end


        %     obj.ClearAllLog
        %     obj.OffRFID
        % end
    end
end
