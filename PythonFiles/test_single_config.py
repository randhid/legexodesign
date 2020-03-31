import scipy.io             # read the matlab file
import numpy as np
from math import *

from MakeDHarray import *       # transfered MATLAB functions
from TransMat import *
from Gt import *
from JacobianCable import *

# NOTE: This file is the single configuration test

# read data from MATLAB file
Data = scipy.io.loadmat('CarexRouting.mat')
CableSeg = Data['CableSeg']
CbRtPtBdId = Data['CbRtPtBdId']
CbRtPtCrd = Data['CbRtPtCrd']

# parameters 
uArm = 0.32
lArm = 0.35

qdeg = np.array([35,-10,30,80])
q = qdeg/180*pi

nJoint = 4
nCable = 7

EffPt4 = np.array([0,0,0,1])
EffPtId = 4

Tmax = 45*np.ones(7)

Gv = np.array([0,-9.81,0])
BdWt = np.array([0,0,0.71,0.6])

BdCoM4 = np.array([[0, 0, 0, 1],
                    [0, 0, 0, 1],
                    [0, 0.083, 0, 1],
                    [-0.185, 0, 0, 1]])


# NOTE: kinetic functions ############################ 

# make DH arrays based on the measured data
DHa = MakeDHarray( q , uArm, lArm)
# print(DHa)

# calculate the tranformation matrix
TransM0 = TransMat( nJoint, DHa )
# print(TransM0)

# calculate the gravity
G = Gt(TransM0,BdWt,BdCoM4,Gv)
# print('G: ', G)

# calculate the cable jacobian
Jc = JacobianCable(nJoint, nCable, TransM0, CableSeg, CbRtPtCrd, CbRtPtBdId )
print('Jc: ', Jc)


# TODO: finish the workflow (testing area) 
# print('##########################################')



# REVIEW: review the parameters by hand 
# print(TransM0)
# print(BdWt)
# print(BdCoM4)
# print(Gv)
# print('##########################################')



