% Bus types
load("soccer-vision/data/bus-types.mat")

% Load Paths
sampleTime = 1/30;

% Imageproperties
imageHeight = 240;
imageWidth = 320;

% VSS_MODE = 1 for Video file, 0 for Gazebo
VSS_MODE = 1;
VSS_PUBLISH_ROS = 1;

% Connect Robot
if VSS_MODE == 0 || VSS_PUBLISH_ROS == 1
    connectrobot;
end
VSS_VIDEO_INPUT=Simulink.Variant('VSS_MODE==1');
VSS_PUBLISH_TO_ROS=Simulink.Variant('VSS_PUBLISH_ROS == 1');

t = Geometry.Transform([0, 0, 1], eul2quat([0, 0, 0]));
camera = Camera.Camera(t, 320, 240);
focal_length = camera.focal_length;

videotestfile = strcat(pwd,'/soccer-vision/media/videos/testvideo.avi');