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


class JointMeasurement:
	"""
	wrapper class for measurement values of a joint
	"""
    def __init__(self):
        self.orientation = (0, 0, 0)
        self.velocity = (0, 0, 0)
        self.position = (0, 0, 0)


class Animation:
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

class RobotState:
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

    def __str__(self):
        return "balance: " + self.balanceState + "\nmotor: " + self.motorState

