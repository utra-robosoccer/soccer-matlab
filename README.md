# soccer-matlab
[![Travis build](https://travis-ci.org/utra-robosoccer/soccer-matlab.svg?branch=master)](https://travis-ci.org/utra-robosoccer/soccer-matlab)

Documentation can be found here for matlab repository 

To get started
```bash
git clone --recurse-submodules https://github.com/utra-robosoccer/soccer-matlab
```
Open matlab, and then open Matlab. (Licenses can be found in our documentation above)
Make sure your matlab's base folder is soccer-matlab. And then run soccer-utility/initialize.m

This will add all the folders to your matlab path

To connect to the robot, to go soccer-utility/connectRobot.m and edit your IP address and the IP address of the robot you are connecting to.

All of the projects, have a simulink file as the main project. These will run soccer-utility/connectRobot.m and run a ros node onto the robot. The exception is soccer-vision, which you can make a setting to not connect to the robot and run a test from a video file
