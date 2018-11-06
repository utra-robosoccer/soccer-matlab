# soccer-matlab
[![Travis build](https://travis-ci.org/utra-robosoccer/soccer-matlab.svg?branch=master)](https://travis-ci.org/utra-robosoccer/soccer-matlab)
[![Total alerts](https://img.shields.io/lgtm/alerts/g/utra-robosoccer/soccer-embedded.svg?logo=lgtm&logoWidth=18)](https://lgtm.com/projects/g/utra-robosoccer/soccer-embedded/alerts/)


### Prerequisites
- Copy of [Matlab](https://www.mathworks.com/support/install-matlab.html), you can find out team's license keys [here](http://utrahumanoid.ca/software-documentation/)
- [ROS Custom Message Support](https://www.mathworks.com/help/robotics/ug/ros-custom-message-support.html)
- [Robotics Toolbox](http://petercorke.com/wordpress/toolboxes/robotics-toolbox)
- [Computer Vision Toolbox](http://petercorke.com/wordpress/toolboxes/machine-vision-toolbox)

### Installation
```bash
git clone --recurse-submodules https://github.com/utra-robosoccer/soccer-matlab
```
- In Matlab, navigate to the soccer-utility directory so you can see all the folders (Note: Never cd into a folder in matlab, always add to path)
- Make a copy of your soccer-utility/connectrobot_example.m to soccer-utility/connectrobot.m
Make sure your matlab's base folder is soccer-matlab. And then run soccer-utility/initialize.m
- Run the soccer-utility/setup.m. This will add all the folders to your matlab path as well as install the ros custom message support. Follow the instructions on the command line prompt

### Testing

##### Testing Soccer Control
Simply run the demo.m file inside soccer-control to show and simulate a sample trajectory
##### Testing Soccer RL
TBD
##### Testing Soccer Strategy (Path finding)
Add the soccer-strategy/test folder to your path and run either soccer-strategy/test-pathfinding.m or soccer-strategy/test-pathfinding-repeat.m for consecutive tests
##### Testing Soccer Vision
Add the soccer-vision/test folder to your path and run any of the tests in the folder

### Running
##### Running Soccer Strategy
- Ensure the IP addresses of your host computer and the robot computer are correct in soccer-utility/connectrobot.m
- Open the soccer-strategy/soccer_strategy.slx simulink file
- Edit the soccer-strategy/soccer_strategy_setup.m file to customize parameters
- Click Run to run the robot autonomously as ROS node, alternatively you can set a run mode on the drop down to run certain functions
##### Running Soccer Vision
- Ensure the IP addresses of your host computer and the robot computer are correct in soccer-utility/connectrobot.m
- Open the soccer-vision/soccer_vision.slx simulink file
- Edit the soccer-vision/soccer_vision_setup.m file to customize parameters
- Click Run to run the computer vision system as a ROS node

### Uploading
##### Uploading Soccer Strategy
- Ensure the IP addresses of your host computer and the robot computer are correct in soccer-utility/connectrobot.m
- Open the soccer-strategy/soccer_strategy.slx simulink file
- Set the run type to External
- Click Run to upload the matlab software onto the robot and run remotely
##### Uploading Soccer Vision
- Ensure the IP addresses of your host computer and the robot computer are correct in soccer-utility/connectrobot.m
- Open the soccer-vision/soccer_vision.slx simulink file
- Set the run type to External
- Click Run to upload the matlab software onto the robot and run remotely
