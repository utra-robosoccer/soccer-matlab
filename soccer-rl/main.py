import tensorflow as tf
import numpy as np
import pybullet as p
import matplotlib as plt
from time import sleep

if __name__ == '__main__':

    # demo 

    # Pybullet Setup
    p.connect(p.GUI)
    plane = p.loadURDF("pybullet/gym/pybullet_data/plane.urdf")
    robot = p.loadURDF("../soccer_description/models/soccerbot/model.xacro")
    p.setGravity(0, 0, -10)

    # Joint info
    for i in range(p.getNumJoints(robot)):
        jointInfo = p.getJointInfo(robot, i)
        print("joint", jointInfo[0], "name=", jointInfo[1].decode('ascii'))

    # Step through simulation
    while(1):
        sleep(0.01)
        pos, orn = p.getBasePositionAndOrientation(robot)
        posmsg = 'pos = {posx:.{prec}f},{posy:.{prec}f},{posz:.{prec}f}   '.format(posx=pos[0], posy=pos[1],
                                                                                   posz=pos[2], prec=5)
        print(posmsg)
        p.stepSimulation()