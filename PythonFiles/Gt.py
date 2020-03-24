# This function accept numpy arrays

from math import *
import numpy as np

# NOTE: Gt find the joint torque due to gravity
#   TransM0 are the transformation matrices;
#   BdWt is the weight of each body;
#   BdCoM4 is the center of mass of each body in LCS;
#   gv is the gravity vector, normally gv should be [0 0 -9.81].

def Gt(TransM0, BdWt, BdCoM4, gv):

    nJ = int(max(TransM0.shape)/4.0 - 1)

    if nJ != max(BdWt.shape):
        print("Error BdWt size")
        return

    G = np.zeros(nJ)


# REVIEW: Go through the process 
    for i in range(nJ):

        BdCoMLCS = np.dot(TransM0[4*(i+1) : 4*(i+1)+4, ...], BdCoM4[i, ...].T )

        # print(TransM0[4*(i+1) : 4*(i+1)+4, ...])
        # print(BdCoM4[i, ...].T)

        Fi = np.dot(BdWt[i], gv)
        # print('Fi: ', Fi)

        for j in range(i + 1):

            Oj = TransM0[4*j:4*j+3, 3]
            zj = TransM0[4*j:4*j+3, 2]
            # print('Oj: ', Oj)
            # print('BdCoMLCS: ', BdCoMLCS)

            Gij = np.dot(np.cross(BdCoMLCS[0:3]-Oj[0:3], Fi), zj)
            # print('G: ', G)
            # print('Gij: ', Gij)

            G[j] = G[j]+Gij
            # print('G: ', G)
            # print('##########################################')
        
    return G

    


    if __name__ == "__main__":

        pass