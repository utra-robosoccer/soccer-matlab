"""
define simulation here 
"""


import os
import sys
import matplotlib as plt
from time import sleep

import pybullet as p
from abc import ABC, abstractmethod

import agent 


class Simulation(ABC):
	""" defines wolrd simulation, include an environment and robot(s)
	"""
	def __init__(self, bot, env=None):
		super().__init__()
		self.bot = bot 
		self.env = None 

	@abstractmethod
	def reset(self):
		raise NotImplementedError

	@abstractmethod
	def step(self):
		raise NotImplementedError

	@abstractmethod
	def render(self):
		raise NotImplementedError


class SoccerSim(Simulation):
	""" simulation for robosoccer 
	"""
	def reset(self):
		p.connect(p.GUI)
		p.setGravity(0, 0, -9.8)


	def step(self, action):
		""" advance 1 step in the simulation"""

		# also need to decide what kind of control, position? torque? 
		p.setJointMotorControlArray(self.bot.body, self.bot.motors, controlMode=p.POSITION_CONTROL,
                                    targetPositions=motorPositions)
		p.stepSimulation()
		sleep(0.01)

		observation = None 
		reward = None 
		done = None 
		info = None 

		return observation, reward, done, info

