"""
Robot and Animations 
"""


import os
import sys
import numpy as np
import matplotlib as plt

import tensorflow as tf
import pybullet as p

import settings
import state 
import policy 


class Robot(object):
    """ 
    """
    def __init__(self, bot_model_path):

        self.init_bot(bot_model_path)
        self.session = None 


    def init_bot(self, bot_model_path):
        """ initialize robot core attributes 
        Args:
            bot_model_path: URDF file
        """
        self.body = p.loadURDF(bot_model_path)
        self.state = state.RobotState()
        self.policy = policy.PPO()

        self.imu = -1
        self.joints = []
        self.motors = []

        # create a list of joints and find the IMU
        for i in range(p.getNumJoints(self.body)):
            self.joints.append(i)
            jointInfo = p.getJointInfo(self.body, i)
            if jointInfo[1].decode('ascii') == "torso_imu":
                self.imu = jointInfo[0]

        # rearrange joint order to match the order of positions found in the csv files. See:
        # https://docs.google.com/spreadsheets/d/1KgIYwm3fNen8yjLEa-FEWq-GnRUnBjyg4z64nZ2uBv8/edit#gid=775054312
        self.motors = self.joints[2:14] + self.joints[17:21] + self.joints[14:16] + self.joints[0:2]

    def get_state(self):
        """ updated state consists of ...
        """


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

