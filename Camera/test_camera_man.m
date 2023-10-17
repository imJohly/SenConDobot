clear

rosshutdown
rosinit

cm = CameraMan();

% while true 
%     cm.camera_update();
%     pause(0.1);
% end

for i = 1:10
    cm.camera_update();
    pause(0.1);
end

rosshutdown