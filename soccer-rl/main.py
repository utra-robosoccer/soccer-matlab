# programming challenge file
import tensorflow as tf
import numpy as np
import pybullet as p
import matplotlib as plt
import time
import csv
import math

# constants
nap_time = 0.01 # simulation time step (100hz freq)
g = (0, 0, -9.8) # gravity

def loadAnimation(animation_path):
    animation = []
    with open(animation_path) as file:
        reader = csv.reader(file)
        for row in reader:
            # convert csv rows to float values
            float_row = [float(val) for val in list(row)] # do i need to cast row as list?
            animation.append(float_row)
    return animation

def getPlane(bullet, theta, alpha):

    x = math.pi * theta / 180.0
    y = math.pi * alpha / 180.0
    return bullet.loadURDF("pybullet/gym/pybullet_data/plane.urdf", baseOrientation=bullet.getQuaternionFromEuler([x, y, 0]))

class Robot:

    def __init__(self, bullet):
        # initialize robot

        self.robot_id = bullet.loadURDF("../soccer_description/models/soccerbot/model.xacro")
        self.num_joints = bullet.getNumJoints(self.robot_id)
        self.motors = self.getMotors(bullet)
        self.animations = {}
        self.tilt_threshold = 0.7 # experimentally chosen
        self.imu_id = 1 # imu located on torso
        self.imu_data = {}
        # states of the robot, all boolean values
        self.states = {
                        'ACTIVE': False,
                        'STABLE': False,
                        'ON_BACK': False,
                        'ON_FRONT': False
                      }
        self.animation_step = {'BACK': -1, 'FRONT': -1}

    # motors must be manually assembled in array according to Joint Table document
    def getMotors(self, bullet):
        joints = []
        for i in range(bullet.getNumJoints(self.robot_id)):
            joints.append(i)
        return joints[2:14] + joints[17:] + joints[14:16] + joints[:2]


    def updateImuInfo(self, bullet):
        # gets and updates info on IMU sensor
        info = bullet.getLinkState(self.robot_id, self.imu_id, computeLinkVelocity=1)
        self.imu_data['POSITION'] = info[0]
        self.imu_data['ORIENTATION'] = info[1]
        self.imu_data['VELOCITY'] = info[6] # linear velocity

    def addAnimations(self, animation_path, animation_key):
        if animation_key in self.animations.keys():
            print("ERROR, KEY {} ALREADY EXISTS!".format(animation_key))
        else:
            self.animations[animation_key] = loadAnimation(animation_path)

    def executeAnimation(self, bullet, animation_key, t):
        if t < len(self.animations[animation_key]):
            animation = self.animations[animation_key][t]
            bullet.setJointMotorControlArray(self.robot_id, self.motors, p.POSITION_CONTROL, targetPositions=animation)
            return True
        else:
            print("ANIMATION STEP BEYOND ANIMATION LENGTH")
            return False
    def displayJointInfo(self, bullet):

        # displays joint info in a nice format
        print("Robot with ID {} has {} joints\n".format(self.robot_id, self.num_joints))
    
        for joint in range(self.num_joints):
            joint_info = bullet.getJointInfo(self.robot_id, joint)
            # print in a nice format
            print("Joint Index: {}".format(joint))
            print("Joint Name: {}".format(joint_info[1]))
            print("Joint Type: {}".format(joint_info[2]))
            print("Q Index: {}".format(joint_info[3]))
            print("U Index: {}".format(joint_info[4]))
            print("Flags: {}".format(joint_info[5]))
            print("Joint Damping: {}".format(joint_info[6]))
            print("Joint Friction: {}".format(joint_info[7]))
            print("Joint Lower Limit: {}".format(joint_info[8]))
            print("Joint Upper Limit: {}".format(joint_info[9]))
            print("Joint Max Force: {}".format(joint_info[10]))
            print("Joint Max Velocity: {}".format(joint_info[11]))
            print("Link Name: {}".format(joint_info[12]))
            print("Joint Axis: {}".format(joint_info[13]))
            print("Parent Frame Position: {}".format(joint_info[14]))
            print("Parent Frame Orientation: {}".format(joint_info[15]))
            print("Parent Index: {}".format(joint_info[16]))
            print("-----------------------------------------")

    def resetStates(self):

        for keys in self.states:
            self.states[keys] = False

    def update_states(self, bullet):
        # updates states of the robot based on avg velocity and pitch
        y_orien = (bullet.getEulerFromQuaternion(self.imu_data['ORIENTATION']))[1]
        vel = self.imu_data['VELOCITY']
        avg_vel = (vel[0] + vel[1] + vel[2]) / 3.0

        if avg_vel < 0.01: # experimentally chosen
            self.resetStates()
            # self.states['ACTIVE'] = False
            if y_orien > self.tilt_threshold:
                # tilted forward
                self.states['ON_FRONT'] = True
                if self.animation_step['FRONT'] == -1:
                    self.animation_step['FRONT'] = 0
            elif y_orien < -self.tilt_threshold:
                # tilted on back
                self.states['ON_BACK'] = True
                if self.animation_step['BACK'] == -1:
                    self.animation_step['BACK'] = 0

            else:
                self.states['STABLE'] = True

        else:
            self.resetStates()
            self.states['ACTIVE'] = True
            pass

    def update(self, bullet):
        # updates every turn

        if self.states['ACTIVE'] or self.states['ON_BACK'] or self.states['ON_FRONT']:
            
            if self.animation_step['BACK'] > -1:
                self.animation_step['BACK'] += 1
                valid_anim = self.executeAnimation(bullet, 'GETUPBACK', self.animation_step['BACK'])
                if not valid_anim:
                    self.animation_step['BACK'] = -1

            elif self.animation_step['FRONT'] > -1:
                self.animation_step['FRONT'] += 1
                valid_anim = self.executeAnimation(bullet, 'GETUPFRONT', self.animation_step['FRONT'])
                if not valid_anim:
                    self.animation_step['FRONT'] = -1

        else:

            self.executeAnimation(bullet, 'STANDING', 0)

if __name__ == '__main__':

    # Pybullet Setup
    p.connect(p.GUI)

    # setup environment
    plane = getPlane(p, 0, -10) # backwards ramp (declination)
    p.setGravity(g[0], g[1], g[2])

    # initialize robot stuffs
    robot = Robot(p)
    robot.updateImuInfo(p)
    robot.addAnimations('trajectories/ready.csv', 'READY')
    robot.addAnimations('trajectories/standing.csv', 'STANDING')
    robot.addAnimations('trajectories/getupfront.csv', 'GETUPFRONT')
    robot.addAnimations('trajectories/getupback.csv', 'GETUPBACK')
    # robot.executeAnimation(p, 'STANDING', 0)
    # robot.displayJointInfo(p)

    # Step through simulation

    # with open('trajectories/getupfront.csv') as file:
    #     reader = csv.reader(file)
    #     for row in reader:
    #         #print(row)
    #         p.setJointMotorControlArray(robot, range(len(list(row))), p.POSITION_CONTROL, targetPositions=[float(val) for val in list(row)])
    
    count = 0
    flag = True

    while(1):
        time.sleep(nap_time)
        pos, orn = p.getBasePositionAndOrientation(robot.robot_id)
        robot.updateImuInfo(p)
        robot.update_states(p)
        robot.update(p)
        # print(p.getEulerFromQuaternion(robot.imu_data['ORIENTATION']))

        # robot.executeAnimation()
        # posmsg = 'pos = {posx:.{prec}f},{posy:.{prec}f},{posz:.{prec}f}   '.\
        # format(posx=pos[0], posy=pos[1],posz=pos[2], prec=5)
        # print(posmsg)
        print(robot.states)
        p.stepSimulation()