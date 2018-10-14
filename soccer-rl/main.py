import tensorflow as tf
import numpy as np
import pybullet as p
import matplotlib as plt
from time import sleep

from agent import Robot 
from environment import Ramp 


if __name__ == '__main__':
    d
    # Pybullet Setup
    p.connect(p.GUI)
    ramp = Ramp("pybullet/gym/pybullet_data/plane.urdf", (0, 0, 0), (0, 0, 0))
    myrobot = Robot()
    p.setGravity(0, 0, -10)

    # Step through simulation
    while(1):
        sleep(0.01)
        pos, orn = p.getBasePositionAndOrientation(myrobot.body)
        myrobot.stabilize()
        p.stepSimulation()