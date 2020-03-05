#MAKEDHARRAY Summary of this function goes here
#   DHpara=[a   d   alpha   theta]

from math import *
import numpy

def MakeDHarray(q , uArm, lArm):

    # rows in DH array

    DHpara0 = [    0,    0,  pi/2, q[0]+pi/2]
    DHpara1 = [    0,    0,  pi/2, q[1]+pi/2]
    DHpara2 = [    0,-uArm,  pi/2, q[2]+pi/2]
    DHpara3 = [ lArm,    0,     0, q[3]-pi/2]

    DHpara = numpy.array((DHpara0, DHpara1, DHpara2, DHpara3))

    return DHpara


if __name__ == "__main__":

    # test unit
    
    q = [1, 2, 3, 4]
    uArm = 2
    lArm = 2

    print(MakeDHarray(q , uArm, lArm))



    