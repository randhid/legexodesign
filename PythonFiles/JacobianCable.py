# REVIEW: Understand the concept

import numpy as np

# NOTE: this file calcuate the cable jacobians 
#   nBody denotes the number of bodies.
#   TransM is 4n by 4 matrix of transformation
#   CableSeg denote each segment of cable, in the format of:
#   [ CableID  Pt1  Pt2; ...];
#   CableID is the id of the Cable, Pt1 & Pt2 is the index in CbRtPtCrd and CbRtPtBdId. 


def JacobianCable(nJoint, nCable, TransM0, CableSeg, CbRtPtCrd4, CbRtPtBdId ):

    # the number of cable segments
    nCableSeg = CableSeg.shape[0]

    # initialize the cable jacobian
    Jc = np.zeros((nCable, nJoint))

    # REVIEW 
    for i in range(nCableSeg):

        # get the current segment
        CableSegCurrent = CableSeg[i, ...]      # get the first row in cable seg series as the current segment
        CableID = CableSegCurrent[0]            # the first element in the current segment is the ID

        # Find Pt1 Coordinate in Global
        Pt1Crd4 = CbRtPtCrd4[CableSegCurrent[1] - 1, ...]       # the second element in the current segment is the coordinate of the first part
        Pt1BdId = CbRtPtBdId[CableSegCurrent[1] - 1, 1]         # find the body id based on the second element in the current segment 

        TransM01 = TransM0[Pt1BdId*4: Pt1BdId*4+4, ...]         # get the corresponding transformation matrix
        Pt1CrdG4 = np.dot(TransM01, Pt1Crd4.T)                  # find the coordinate in the global 

        # Find Pt2 Coordinate in Global
        Pt2Crd4 = CbRtPtCrd4[CableSegCurrent[2] - 1, ...]       # the third element in the current segment is the coordinate of the second part
        Pt2BdId = CbRtPtBdId[CableSegCurrent[2] - 1, 1]         # find the body id based on the thrid element in the current segment

        TransM02  =TransM0[Pt2BdId*4: Pt2BdId*4+4, ...]         # get the corresponding transformation matrix
        Pt2CrdG4 = np.dot(TransM02, Pt2Crd4.T)                  # find the coordinate in the global 

        # Find unit cable force
        f = Pt1CrdG4[0:3] - Pt2CrdG4[0:3]                       # get the difference between coordinate of part 1 and part 2
        f = f/np.linalg.norm(f)                                 # normalize the difference

        # return f

        # Jc(CableID, j)=(rj x F) . zj AND ri = Pt - Oj
        # Note that Joint j is on Body j-1, which means O(j)=TransM0(j-1)
        for j in range(Pt2BdId - Pt1BdId):

            JtId = Pt2BdId - j                  # tension jacobian ID
            Oj = TransM0[JtId*4-4:JtId*4-1, 3]     # corresponding transform matrix
            zj = TransM0[JtId*4-4:JtId*4-1, 2]     # corresponding transform matrix
            Jj = np.dot(np.cross(Pt2CrdG4[0:3]-Oj, f), zj)

            Jc[CableID-1, JtId-1] = Jc[CableID-1, JtId-1] + Jj

            # print(Jc)

    return Jc