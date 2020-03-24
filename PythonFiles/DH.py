from math import *
import numpy

# NOTE: This file generates the transform matrix of each individual link based on the DH notation
# DH function receives a list of DH notation
# dh = [a, d, alpha, theta]


def DH(dh):

    # Identity Matrix
    T = numpy.eye(4, 4)

    # first row
    T[0][0] = cos(dh[3])
    T[0][1] = -sin(dh[3]) * cos(dh[2])
    T[0][2] = sin(dh[3]) * sin(dh[2])
    T[0][3] = dh[0] * cos(dh[3])

    # second row
    T[1][0] = sin(dh[3])
    T[1][1] = cos(dh[3]) * cos(dh[2])
    T[1][2] = -cos(dh[3]) * sin(dh[2])
    T[1][3] = dh[0] * sin(dh[3])

    # third row
    T[2][1] = sin(dh[2])
    T[2][2] = cos(dh[2])
    T[2][3] = dh[1]

    return T


if __name__ == "__main__":

    print("\nDH.py example:\n")

    dh = [1, 2, 3, 4]
    #dh = list(int(num) for num in input("Input a test dh set (seperate by space): ").strip().split())

    T = DH(dh)

    # print("The T for dh = {} is :\n{}".format(dh, T))
    print(T)
