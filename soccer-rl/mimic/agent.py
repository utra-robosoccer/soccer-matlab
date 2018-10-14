"""
Robot and Animations 
"""


import os
import sys
import settings
import state 
import policy 

import numpy as np
import pybullet as p
import tensorflow as tf
import matplotlib as plt

from time import sleep



class Robot(object):
    """ Bot la
    """

    # maximum pitch beyond which the robot is to be considered tilted
    MAX_ALLOWED_PITCH = 0.785398163

    def __init__(self):

        # core attributes 
        self.state = None 
        self.policy = None 
        self.session = None 
        

        # initialize robot
        self.body = p.loadURDF("../soccer_description/models/soccerbot/model.xacro")
        self.state = RobotState()
        self.imu = -1
        self.imuMeasurements = JointMeasurement()
        self.joints = []
        self.motors = []

        # create a list of joints and find the IMU
        for i in range(p.getNumJoints(self.body)):
            self.joints.append(i)
            jointInfo = p.getJointInfo(self.body, i)
            if jointInfo[1].decode('ascii') == "torso_imu":
                self.imu = jointInfo[0]

        if self.imu == -1:
            raise AttributeError("Could not find robot's imu sensor from joint list")

        # rearrange joint order to match the order of positions found in the csv files. See:
        # https://docs.google.com/spreadsheets/d/1KgIYwm3fNen8yjLEa-FEWq-GnRUnBjyg4z64nZ2uBv8/edit#gid=775054312
        self.motors = self.joints[2:14] + self.joints[17:21] + self.joints[14:16] + self.joints[0:2]

        # initialize animations
        self.getupBackAnimation = Animation("./trajectories/getupback.csv")
        self.getupFrontAnimation = Animation("./trajectories/getupfront.csv")
        self.readyAnimation = Animation("./trajectories/ready.csv")
        self.standingAnimation = Animation("./trajectories/standing.csv")
        self.activeAnimation = None

    def updateImuMeasurments(self):
    	"""Get IMU measurements from simulation and convert to usable format"""
        imu_info = p.getLinkState(self.body, self.imu, computeLinkVelocity=1)
        self.imuMeasurements.position = imu_info[0]
        self.imuMeasurements.orientation = p.getEulerFromQuaternion(imu_info[1])
        self.imuMeasurements.velocity = imu_info[6]

    def updateBalanceState(self):
    	"""Interpret IMU measurements to determine if the robot is tilted. updates state accordingly"""
        self.updateImuMeasurments()
        pitch = self.imuMeasurements.orientation[1]

        if pitch >= self.MAX_ALLOWED_PITCH:
            self.state.balanceState = self.state.TILTED_FORWARD
        elif pitch <= (-1.0) * self.MAX_ALLOWED_PITCH:
            self.state.balanceState = self.state.TILTED_BACK
        else:
            self.state.balanceState = self.state.STABLE

    def runAnimation(self, motorPositions):
    	"""Receives a list of positions and applies it motors"""
        p.setJointMotorControlArray(self.body, self.motors, controlMode=p.POSITION_CONTROL,
                                    targetPositions=motorPositions)

    def stabilize(self):
    	"""
	    Attempts to keep the robot standing up by running animations based on state.
	    Animations will only run when the robot is relatively stationary i.e. this will allow the robot to fully
	    fall and then try to get it to stand up again
    	"""
        if self.state.motorState == self.state.DEACTIVE:
            self.updateBalanceState()
            if sum(self.imuMeasurements.velocity) < 0.05:
                if self.state.balanceState == self.state.TILTED_BACK:
                    self.activeAnimation = self.getupBackAnimation
                    self.state.motorState = self.state.ACTIVE

                elif self.state.balanceState == self.state.TILTED_FORWARD:
                    self.activeAnimation = self.getupFrontAnimation
                    self.state.motorState = self.state.ACTIVE

        elif self.state.motorState == self.state.ACTIVE:
            self.runAnimation(self.activeAnimation.run())

            # Whenever an animation is done,
            #   if the robot is balanced,
            #       run the ready animation in the next iteration to keep it balanced
            #       stop animations after running ready
            #   else
            #       just stop the animation and check balance in the next iteration
            if self.activeAnimation.isDone():
                self.activeAnimation.reset()
                if self.state.balanceState == self.state.STABLE and self.activeAnimation != self.readyAnimation:
                        self.activeAnimation = self.readyAnimation
                else:
                    self.activeAnimation.reset()
                    self.activeAnimation = None
                    self.state.motorState = self.state.DEACTIVE

