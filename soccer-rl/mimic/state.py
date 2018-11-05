"""
Robot and Animations 
"""

import pybullet as p
import matplotlib as plt
from time import sleep

import sys
import os
import settings
import networks
import numpy as np
import tensorflow as tf


class JointMeasurement(object):
	"""
	wrapper class for measurement values of a joint
	"""
    def __init__(self):
        jointStates = p.getJointStates(object.body, object.joints)
        linkStates = []
        for i in len(range(object.joints)):
            linkStates.append(p.getLinkState(object.body, object.joints))

        self.orientation = [linkState[2] for linkState in linkStates]
        self.positions = [jointState[0] for jointState in jointStates]
        self.velocity = [jointState[1] for jointState in jointStates]


class Animation(object):
	"""
	Encapsulates a trajectory, its total length, and current state.
	Caller is responsible for checking to see if the animation is done and resetting when appropriate.
	"""
    def __init__(self, path):
        self.loadTrajectoryCSV(path)
        self.currentTimer = 0
        self.length = len(self.trajectory)

    def loadTrajectoryCSV(self, path):
    	"""
	    loads joint positions for a trajectory from a CSV file into a 2-D list where each one of the inner lists
	    is a list of positions for each joint at a single instance of time
    	"""
        self.trajectory = []
        with open(path, 'r') as inFile:
            for line in inFile:
                self.trajectory.append(list(map(float, line.split(','))))

    def run(self):
    	"""returns joint positions at current time of trajectory"""
        if (self.currentTimer < self.length):
            rval = self.trajectory[self.currentTimer]
            self.currentTimer += 1
            return rval
        else:
            raise IndexError("Attempted to run a finished animation.")

    def isDone(self):
        return self.currentTimer == self.length

    def reset(self):
        self.currentTimer = 0

class RobotState(object):
	"""
	Encapsulates robot state. Do not directly assign to state parameters. Use the predefined values instead
	"""

    # motor states
    ACTIVE = "ACTIVE"
    DEACTIVE = "DEACTIVE"

    # balance stats
    STABLE = "STABLE"
    TILTED_BACK = "TILTED_BACK"
    TILTED_FORWARD = "TILTED_FORWARD"

    def __init__(self):
        self.motorState = self.DEACTIVE
        self.balanceState = self.STABLE
        self.imuMeasurements = JointMeasurement()

    def __str__(self):
        return "balance: " + self.balanceState + "\nmotor: " + self.motorState

