import tensorflow as tf
import numpy as np
import pybullet as p
import matplotlib as plt
from time import sleep
import csv


def import_float_csv(file_name):
    csvlist = []
    with open(file_name, 'rt', encoding='ascii') as csvfile:
        reader = csv.reader(csvfile, dialect='excel', quoting=csv.QUOTE_NONNUMERIC)
        for x, row in enumerate(reader):
            float_row = []
            for y, val in enumerate(row):
                float_row.append(float(val))
            csvlist.append(float_row)
    return csvlist


class Humanoid:
    def __init__(self):
        self.bodyID = p.loadURDF("../soccer_description/models/soccerbot/model.xacro", no_translation,
                                 quaternion_rotation)

        self.standing_trajectory = import_float_csv('trajectories\standing.csv')
        self.ready_trajectory = import_float_csv(r'trajectories\ready.csv')
        self.getupback_trajectory = import_float_csv('trajectories\getupback.csv')
        self.getupfront_trajectory = import_float_csv('trajectories\getupfront.csv')

        self.standing_trajectory.reverse()
        self.ready_trajectory.reverse()
        self.getupback_trajectory.reverse()
        self.getupfront_trajectory.reverse()

        self.getupback_timer = -1
        self.getupback_totaltime = len(self.getupback_trajectory)

        self.getupfront_timer = -1
        self.getupfront_totaltime = len(self.getupfront_trajectory)

        self.IMU_ID = -1
        self.joints = []
        for index in range(p.getNumJoints(self.bodyID)):
            if index > 0:
                self.joints.append(index)
            info = p.getJointInfo(self.bodyID, index)
            if info[1].decode('ascii') == 'torso_imu':
                self.IMU_ID = info[0]
        self.discrete_state = ['rest', 'stable']
        self.IMU_measurement = []

        #PRINTS
        print('getupback_totaltime: {}'.format(self.getupback_totaltime))
        print('getupfront_totaltime: {}'.format(self.getupfront_totaltime))
        print('Number of Joints: {}'.format(p.getNumJoints(self.bodyID)))

    def get_discrete_state(self):
        avg_velocity = 0

        for vel in self.IMU_measurement[2]:
            avg_velocity = avg_velocity + abs(vel)
        avg_velocity = avg_velocity / 3

        if avg_velocity < 0.001 and self.getupfront_timer == -1 and self.getupback_timer == -1:
            self.discrete_state[0] = 'rest'
            if self.IMU_measurement[1][1] < -0.1:
                self.discrete_state[1] = 'back'
            elif self.IMU_measurement[1][1] > 0.1:
                self.discrete_state[1] = 'front'
            else:
                self.discrete_state[1] = 'stable'
        else:
            self.discrete_state[0] = 'active'
            if self.getupfront_timer == -1 and self.getupback_timer == -1:
                self.discrete_state[1] = 'falling'
            elif self.getupback_timer != -1:
                self.discrete_state[1] = 'back'
            elif self.getupfront_timer != -1:
                self.discrete_state[1] = 'front'
        print('Discrete State: (' + self.discrete_state[0] + ', ' + self.discrete_state[1] + ')')

    def get_imu_measurements(self):
        imu_state = p.getLinkState(self.bodyID, self.IMU_ID, computeLinkVelocity=1)
        imu_pos = imu_state[0]
        imu_euler_orientation = p.getEulerFromQuaternion(imu_state[1])
        imu_vel = imu_state[6]
        self.IMU_measurement = [imu_pos, imu_euler_orientation, imu_vel]

    def getupback(self):
        if self.getupback_timer == self.getupback_totaltime:
            self.getupback_timer = -1
            self.stand()
            return
        elif self.getupback_timer == -1:
            self.getupback_timer = 0

        print('getupback_timer: {}'.format(self.getupback_timer))
        p.setJointMotorControlArray(self.bodyID, self.joints, controlMode=p.POSITION_CONTROL,
                                    targetPositions=self.getupback_trajectory[self.getupback_timer])
        self.getupback_timer = self.getupback_timer + 1

    def getupfront(self):
        if self.getupfront_timer == self.getupfront_totaltime:
            self.getupfront_timer = -1
            self.stand()
            return
        elif self.getupfront_timer == -1:
            self.getupfront_timer = 0

        print("getupfront_timer: {}".format(self.getupfront_timer))
        p.setJointMotorControlArray(self.bodyID, self.joints, controlMode=p.POSITION_CONTROL,
                                    targetPositions=self.getupfront_trajectory[self.getupfront_timer])
        self.getupfront_timer = self.getupfront_timer + 1

    def stand(self):
        p.setJointMotorControlArray(self.bodyID, self.joints, controlMode=p.POSITION_CONTROL,
                                    targetPositions=self.standing_trajectory[0])

    def ready(self):
        p.setJointMotorControlArray(self.bodyID, self.joints, controlMode=p.POSITION_CONTROL,
                                    targetPositions=self.ready_trajectory[0])

    def stabilize(self):
        self.get_imu_measurements()
        self.get_discrete_state()
        if self.discrete_state[0] == 'rest':
            if self.discrete_state[1] == 'back':
                self.getupback()
                return
            elif self.discrete_state[1] == 'front':
                self.getupfront()
                return
            elif self.discrete_state[1] == 'stable':
                self.stand()
        elif self.discrete_state[0] == 'active':
            if self.discrete_state[1] == 'falling':
                return
            elif self.discrete_state[1] == 'back':
                self.getupback()
                return
            elif self.discrete_state[1] == 'front':
                self.getupfront()
                return

if __name__ == '__main__':

    # demo

    # Pybullet Setup
    p.connect(p.GUI)
    plane = p.loadURDF("pybullet/gym/pybullet_data/plane.urdf")

    no_translation = [0, 0, 0]
    euclidean_rotation = [0,0,0]
    quaternion_rotation = p.getQuaternionFromEuler(euclidean_rotation)

    #Create Humanoid
    soccerbot = Humanoid()
    #robot = p.loadURDF("../soccer_description/models/soccerbot/model.xacro", no_translation, quaternion_rotation)
    p.setGravity(0, 0, -10)

    # Joint info
    for i in range(p.getNumJoints(soccerbot.bodyID)):
        jointInfo = p.getJointInfo(soccerbot.bodyID, i)
        print("joint", jointInfo[0], "name=", jointInfo[1].decode('ascii'))

    #Start Standing
    soccerbot.ready()

    # Step through simulation
    counter = 0
    while(1):
        sleep(0.01)
        #Stabilize Robot
        soccerbot.stabilize()

        #PRINTS
        pos, orn = p.getBasePositionAndOrientation(soccerbot.bodyID)
        posmsg = 'pos = {posx:.{prec}f},{posy:.{prec}f},{posz:.{prec}f}   '.format(posx=pos[0], posy=pos[1],
                                                                                   posz=pos[2], prec=5)
        #print(posmsg)

        print('Elapsed: {time:.{prec}f}s' .format(time = (counter*0.01), prec=3))
        counter = counter + 1
        IMU_joint_state = p.getJointState(soccerbot.bodyID, 1)
        IMU_link_state = p.getLinkState(soccerbot.bodyID, 1, computeLinkVelocity=1)
        IMU_euler_orientation = p.getEulerFromQuaternion(IMU_link_state[1])
        print('IMU_joint_pos = {pos:.{prec}f}'.format(pos = IMU_joint_state[0], prec=5))
        print('IMU_linkworldpos = {posx:.{prec}f}, {posy:.{prec}f}, {posx:.{prec}f}' .format(
                                                                                         posx = IMU_link_state[0][0],
                                                                                         posy = IMU_link_state[0][1],
                                                                                         posz = IMU_link_state[0][2],
                                                                                         prec = 5))
        print('IMU_worldLinkFramePos = {posx:.{prec}f}, {posy:.{prec}f}, {posx:.{prec}f}'.format(
                                                                                        posx=IMU_link_state[4][0],
                                                                                        posy=IMU_link_state[4][1],
                                                                                        posz=IMU_link_state[4][2],
                                                                                        prec=5))
        print('IMU_euler_orientation = {posx:.{prec}f}, {posy:.{prec}f}, {posx:.{prec}f}'.format(
                                                                                        posx=IMU_euler_orientation[0],
                                                                                        posy=IMU_euler_orientation[1],
                                                                                        posz=IMU_euler_orientation[2],
                                                                                        prec=5))
        print('IMU_link_vel = {posx:.{prec}f}, {posy:.{prec}f}, {posx:.{prec}f}'.format(posx=IMU_link_state[6][0],
                                                                                        posy=IMU_link_state[6][1],
                                                                                        posz=IMU_link_state[6][2],
                                                                                        prec=5))
        print('')
        #END OF PRINTS

        p.stepSimulation()

