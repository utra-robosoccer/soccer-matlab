import tensorflow as tf
import numpy as np
import pybullet as p
import matplotlib as plt
from time import sleep
import csv

#Class of Environment, loads up specified environment name in pybullet_data folder, can only translate and rotate urdf
#I have not been able to change orientation or position during run time, so this class is nonfunctional
class Environment:
    def __init__(self, path, axis, angle):
        self.orientation = [0, 0, 0]
        self.orientation[axis] = angle*2*3.14159/360
        self.position = [0, 0, 0]
        self.path = path
        self.wobble_counter = 0
        self.wobble_direction = 1

        if '.urdf' in self.path:
            self.ID = p.loadURDF(self.path, self.position, p.getQuaternionFromEuler(self.orientation))
        elif '.sdf' in self.path:
            self.ID = p.loadSDF(self.path)
        elif '.bullet' in self.path:
            self.ID = p.loadBullet(self.path)
        elif '.mjcf' in self.path:
            self.ID = p.loadMJCF(self.path)

    def setposition(self, new_position):
        self.position = new_position
        if len(self.ID) == 1:
            self.ID = p.loadURDF(self.path, self.position, p.getQuaternionFromEuler(self.orientation))

    def setorientation(self, new_orientation):
        self.orientation = new_orientation
        if len(self.ID) == 1:
            self.ID = p.loadURDF(self.path, self.position, p.getQuaternionFromEuler(self.orientation))

    def wobble(self, axis, maxangle, stepangle):
        maxangle = maxangle*2*3.14159/360
        stepangle = stepangle *2*3.14159/360
        self.wobble_counter = self.wobble_counter + self.wobble_direction
        angle = stepangle*self.wobble_counter
        if angle > maxangle:
            self.wobble_direction = -1
            self.wobble_counter = self.wobble_counter + self.wobble_direction
            angle = stepangle*self.wobble_counter
        self.orientation[axis] = angle
        self.setposition(self.orientation)

    def rotate(self, axis, angle):
        angle = angle*2*3.14159/360
        self.orientation[axis] = angle

#Function to import trajectories folder into 2-Dimensional List
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

#Class of Humanoid Robot, loads up trajectories and URDF upon creation
class Humanoid:
    def __init__(self):
        #Load URDF
        self.bodyID = p.loadURDF("../soccer_description/models/soccerbot/model.xacro")

        #Load Trajectories
        self.standing_trajectory = import_float_csv('trajectories\standing.csv')
        self.ready_trajectory = import_float_csv(r'trajectories\ready.csv')
        self.getupback_trajectory = import_float_csv('trajectories\getupback.csv')
        self.getupfront_trajectory = import_float_csv('trajectories\getupfront.csv')

        #Initiate control counters for trajectories animation
        self.getupback_timer = -1
        self.getupback_totaltime = len(self.getupback_trajectory)

        self.getupfront_timer = -1
        self.getupfront_totaltime = len(self.getupfront_trajectory)

        #Define total joints list and joint ID of IMU
        self.IMU_ID = -1
        self.joints = []

        for index in range(p.getNumJoints(self.bodyID)):
            self.joints.append(index)
            info = p.getJointInfo(self.bodyID, index)
            if info[1].decode('ascii') == 'torso_imu':
                self.IMU_ID = info[0]

        #Re-arrange joint order to match Motor indices in trajectories
        self.motors = self.joints[2:14] + self.joints[17:21] + self.joints[14:16] + self.joints[0:2]

        #Initialize starting state as in 'rest' and 'stable'
        self.discrete_state = ['rest', 'stable']
        self.IMU_measurement = []

    #Method to retrieve relevant IMU information
    #Returns position, orientation, and velocity of IMU joint using pybullet functions
    def get_imu_measurements(self):
        imu_state = p.getLinkState(self.bodyID, self.IMU_ID, computeLinkVelocity=1)
        imu_pos = imu_state[0]
        imu_euler_orientation = p.getEulerFromQuaternion(imu_state[1])
        imu_vel = imu_state[6]
        self.IMU_measurement = [imu_pos, imu_euler_orientation, imu_vel]

    #Method to take IMU measurments and determine the movement and orientation of the robot into a qualitative
    #descrete way: 1. Rest/Active 2. Back/Front/Stable(Rest) or Falling(Active), where Back and Front mean orientation
    #of fallen robot if at Rest or direction of getting up if Active
    def get_discrete_state(self):
        avg_velocity = 0

        for vel in self.IMU_measurement[2]:
            avg_velocity = avg_velocity + abs(vel)
        avg_velocity = avg_velocity / 3

        if avg_velocity < 0.0025 and self.getupfront_timer == -1 and self.getupback_timer == -1:
            self.discrete_state[0] = 'rest'
            if self.IMU_measurement[1][1] < -0.707:
                self.discrete_state[1] = 'back'
            elif self.IMU_measurement[1][1] > 0.707:
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

    #Method to execute getupback sequence, makes use of a counter to determine current joint positions
    def getupback(self):
        if self.getupback_timer == self.getupback_totaltime:
            self.getupback_timer = -1
            self.stand()
            return
        elif self.getupback_timer == -1:
            self.getupback_timer = 0

        print('getupback_timer: {}'.format(self.getupback_timer))
        p.setJointMotorControlArray(self.bodyID, self.motors, controlMode=p.POSITION_CONTROL,
                                    targetPositions=self.getupback_trajectory[self.getupback_timer])
        self.getupback_timer = self.getupback_timer + 1

    #Method to exectue getupfront sequence
    def getupfront(self):
        if self.getupfront_timer == self.getupfront_totaltime:
            self.getupfront_timer = -1
            self.stand()
            return
        elif self.getupfront_timer == -1:
            self.getupfront_timer = 0

        print("getupfront_timer: {}".format(self.getupfront_timer))
        p.setJointMotorControlArray(self.bodyID, self.motors, controlMode=p.POSITION_CONTROL,
                                    targetPositions=self.getupfront_trajectory[self.getupfront_timer])
        self.getupfront_timer = self.getupfront_timer + 1

    #Method to lock all joints at angle 0
    def stand(self):
        p.setJointMotorControlArray(self.bodyID, self.motors, controlMode=p.POSITION_CONTROL,
                                    targetPositions=self.standing_trajectory[0])

    #Method to get robot in ready position
    def ready(self):
        p.setJointMotorControlArray(self.bodyID, self.motors, controlMode=p.POSITION_CONTROL,
                                    targetPositions=self.ready_trajectory[0])

    #Method to keep robot standing. Makes use of discrete states to determine whether which trajectory sequence to
    #execute.
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
            elif self.discrete_state[1] == 'front':
                self.getupfront()
                return

if __name__ == '__main__':
    # Pybullet Setup
    p.connect(p.GUI)

    plane = Environment("pybullet/gym/pybullet_data/plane.urdf", 1, -5)

    #Create Humanoid
    soccerbot = Humanoid()
    p.setGravity(0, 0, -10)

    # Joint info
    for i in range(p.getNumJoints(soccerbot.bodyID)):
        jointInfo = p.getJointInfo(soccerbot.bodyID, i)
        print("joint", jointInfo[0], "name=", jointInfo[1].decode('ascii'))

    #Start Standing
    soccerbot.stand()

    # Step through simulation
    counter = 0
    while(1):
        sleep(0.01)
        #Stabilize Robot
        soccerbot.stabilize()

        #PRINTS
        print('Elapsed: {time:.{prec}f}s'.format(time=(counter * 0.01), prec=3))
        counter = counter + 1

        pos, orn = p.getBasePositionAndOrientation(soccerbot.bodyID)
        posmsg = 'Base Position = {posx:.{prec}f},{posy:.{prec}f},{posz:.{prec}f}   '.format(posx=pos[0], posy=pos[1],
                                                                                   posz=pos[2], prec=5)
        IMU_joint_state = p.getJointState(soccerbot.bodyID, 1)
        IMU_link_state = p.getLinkState(soccerbot.bodyID, 1, computeLinkVelocity=1)
        IMU_euler_orientation = p.getEulerFromQuaternion(IMU_link_state[1])
        print('IMU Joint Position = {pos:.{prec}f}'.format(pos = IMU_joint_state[0], prec=5))
        print('IMU Link World Position = {posx:.{prec}f}, {posy:.{prec}f}, {posx:.{prec}f}' .format(
                                                                                         posx = IMU_link_state[0][0],
                                                                                         posy = IMU_link_state[0][1],
                                                                                         posz = IMU_link_state[0][2],
                                                                                         prec = 5))
        print('IMU WorldLink Frame Posistion = {posx:.{prec}f}, {posy:.{prec}f}, {posx:.{prec}f}'.format(
                                                                                        posx=IMU_link_state[4][0],
                                                                                        posy=IMU_link_state[4][1],
                                                                                        posz=IMU_link_state[4][2],
                                                                                        prec=5))
        print('IMU Euler Orientation = {posx:.{prec}f}, {posy:.{prec}f}, {posx:.{prec}f}'.format(
                                                                                        posx=IMU_euler_orientation[0],
                                                                                        posy=IMU_euler_orientation[1],
                                                                                        posz=IMU_euler_orientation[2],
                                                                                        prec=5))
        print('IMU Link Velocity = {posx:.{prec}f}, {posy:.{prec}f}, {posx:.{prec}f}'.format(posx=IMU_link_state[6][0],
                                                                                        posy=IMU_link_state[6][1],
                                                                                        posz=IMU_link_state[6][2],
                                                                                        prec=5))
        print('')
        #END OF PRINTS

        p.stepSimulation()

