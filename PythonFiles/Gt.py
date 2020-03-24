# This function accept numpy arrays

from math import *
import numpy

# NOTE: Gt find the joint torque due to gravity
#   TransM0 are the transformation matrices;
#   BdWt is the weight of each body;
#   BdCoM4 is the center of mass of each body in LCS;
#   gv is the gravity vector, normally gv should be [0 0 -9.81].

# the function accept numpy arrays

def Gt(TransM0, BdWt, BdCoM4 ,gv):

    nJ = max(TransM0.shape)/4.0 - 1

    if nJ != max(BdWt.shape):
        print("Error BdWt size")
        return

    G = numpy.zeros((1, nJ))

    for i in range(nJ):

        BdCoMLCS = ""   # TODO: the dimensions in MATLAB (4*i+1:4*i+4,:)

        Fi = BdWt(i)*gv

        for j in range(i):  # TODO: Understand this part

            Oj = ""
            zj = ""
            Gij = ""

            G[j] = ""


    return G