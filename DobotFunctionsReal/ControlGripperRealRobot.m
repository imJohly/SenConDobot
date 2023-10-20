function  ControlGripperRealRobot(state)
%CONTROLGRIPPERREALROBOT Summary of this function goes here
%[1 0] open gripper
%[1 1] close Gripper

%Check ros initilised?

% Turn on the tool
[toolStatePub, toolStateMsg] = rospublisher('/dobot_magician/target_tool_state');
if state
    %open gripper if state is true
    toolStateMsg.Data = [1 0];
    send(toolStatePub,toolStateMsg);
    fprintf('Openning Gripper\n');
else
    %otherwise close gripper
    toolStateMsg.Data = [1 1];
    send(toolStatePub,toolStateMsg);
    fprintf('Closing Gripper\n');
end

toolStateSubscriber = rossubscriber('/dobot_magician/tool_state');
pause(1); %Allow some time for MATLAB to start the subscriber
currentToolState = toolStateSubscriber.LatestMessage.Data;

end

