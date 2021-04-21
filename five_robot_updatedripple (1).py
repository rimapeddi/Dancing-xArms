#!/usr/bin/env python3
import os
import sys
import time
import csv
import socket
import serial
import pyfirmata
import numpy as np

# board = pyfirmata.Arduino('/dev/ttyACM0')
# it = pyfirmata.util.Iterator(board)

# it.start()
# sys.path.append(os.path.join(os.path.dirname(__file__), '../../..'))
from xarm.wrapper import XArmAPI
arm1 = XArmAPI('192.168.1.204')
arm2 = XArmAPI('192.168.1.226')
arm5 = XArmAPI('192.168.1.215')
arm3 = XArmAPI('192.168.1.208')
arm4 = XArmAPI('192.168.1.206')
arm6 = XArmAPI('192.168.1.234')



arms = [arm1,arm2,arm3,arm4, arm5]
totalArms = len(arms)
sampleTime = .008
armdeg = [53,141,190,-108,-47]



def cvt(path):
    return_vector = []
    for i in range(7):
            return_vector.append( float(path[i]))
    return return_vector

path_j = []
path_k = []
path_l = []

with open('/home/codmusic/Desktop/MAtlab/bin/ripple.csv', newline='') as csvfile:
    with open('/home/codmusic/Desktop/MAtlab/bin/guilt.csv', newline='') as csvfile1:
        with open('/home/codmusic/Desktop/MAtlab/bin/joy4.csv', newline='') as csvfile2:
            paths_reader_j = csv.reader(csvfile, delimiter=',', quotechar='|')
            paths_reader_k = csv.reader(csvfile1, delimiter=',', quotechar='|')
            paths_reader_l = csv.reader(csvfile2, delimiter=',', quotechar='|')
    
            time.sleep(3)
            for path in paths_reader_j:
                    path_j.append(cvt(path))
            for path in paths_reader_k:
                    path_k.append(cvt(path))
            for path in paths_reader_l:
                    path_l.append(cvt(path))


arm6.set_simulation_robot(on_off=False)
arm6.clean_warn()
arm6.clean_error()

for a in range(totalArms):
        arms[a].set_simulation_robot(on_off=False)
        arms[a].clean_warn()
        arms[a].clean_error()
        arms[a].set_mode(0)
        arms[a].set_state(0)
        arms[a].set_servo_angle(angle=[0.0, 0.0, 0.0, 1.5708, 0.0, 0.0, 0.0], wait=True, speed=0.5, acceleration = 0.5, is_radian=True)


path1 =[]
path2 =[]
path3 =[]
# now comes the main loop with right timing

robot = 0
pos = 0
print("ready")
#Here is where it is slow I have tried changing speed

b=0

robotVec = range(0, totalArms)
delayTime = 1.0
totalT = .008*len(path_j) + delayTime*(int(totalArms))

while b < 4:
    robot = int(input("which robot would you like to ripple with?"))
    b = b+1
    deg = armdeg[robot-1]
    #robot = robot-1
    length = len(path_j)
    i= 0
    k=0
    q = np.zeros(totalArms)
    currentTime = i*sampleTime
    while currentTime < totalT:
        k = k + 1
        print(k, currentTime)
        currentTime = k*sampleTime

        for x in range(totalArms):
            if currentTime > abs(robot-x)*(delayTime) - sampleTime and currentTime < abs(robot-x)*(delayTime) + .008*len(path_j) - .016 :
                q[x] = q[x] + 1
            arms[x].set_mode(1)
            arms[x].set_state(0)
            print( q[x],arms[x].set_servo_angle_j(angles=path_j[int(q[x])],is_radian=False))
        #start_time = time.time() 
        
         #this one moves fine
         #tts = time.time() - start_time
         #if tts > 0.008:
           # tts = 0
         # print(tts)
         # time.sleep(0.008-tts)
        
            
# release all event
# for a in range(6):
#     if hasattr(arms[a], 'release_count_changed_callback'):
#         arms[a].release_count_changed_callback(count_changed_callback)
#         arms[a].release_error_warn_changed_callback(state_changed_callback)
#         arms[a].release_state_changed_callback(state_changed_callback)
#         arms[a].release_connect_changed_callback(error_warn_change_callback)
