%% Setup
rosshutdown
pause(1);
rosinit('localhost',11311); 
disp('yep we started');
buttonSub = rossubscriber('button_state', 'std_msgs/Bool');
disp('Subbing?');
%% Logging set up
%L = log4matlab('AssignmentLog.log');

%% Get Estop data
buttonData = receive(buttonSub) ;
isEStopPressed = buttonData.Data;

disp('getting');

while true

isEStopPressed = receive(buttonSub).Data;  % ############# Test if this works in one line

if isEStopPressed
    %L.mlog = {L.WARN,'Assingment1',['E Stop Pressed. Program Halted']};
    disp('E Stop Pressed. Program Halted');
    break
end

end


%% Close logging
%edit('AssignmentLog.log');