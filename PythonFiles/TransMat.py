from math import *
from DH import *
import numpy

# NOTE: this file calcuate the transform matrix from base frame to the end effector frame
# transformation matrix

# Output a (nJoint+1, 4) size matrix


def TransMat(nJoint, Dharray):

    TransM0 = numpy.zeros((4*(nJoint+1), 4))

    TransM0[0:4] = numpy.eye(4)

    for i in range(nJoint):
        TransM0[(i+1)*4:(i+1)*4+4] = numpy.dot( TransM0[i*4:(i+1)*4], DH(Dharray[i]) )

    return TransM0


if __name__ == "__main__":

    nJoint = 2
    Dharray = numpy.array(((0, 1, 2, 3),(4, 5, 6, 7)))

    print(TransMat(nJoint, Dharray))