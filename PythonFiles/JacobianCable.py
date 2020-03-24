# TODO: Understand the concept

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
    i = 0

    # get the current segment
    CableSegCurrent = CableSeg[i, ...]
    CableID = CableSegCurrent[0]

    # Find Pt1 Coordinate in Global
    Pt1Crd4 = CbRtPtCrd4[CableSegCurrent[1] - 1, ...]
    Pt1BdId = CbRtPtBdId[CableSegCurrent[1] - 1, 1]

    TransM01 = TransM0[Pt1BdId*4: Pt1BdId*4+4, ...]
    Pt1CrdG4 = np.dot(TransM01, Pt1Crd4.T)

    # Find Pt2 Coordinate in Global
    Pt2Crd4 = CbRtPtCrd4[CableSegCurrent[2] - 1, ...]
    Pt2BdId = CbRtPtBdId[CableSegCurrent[2] - 1, 1]

    TransM02  =TransM0[Pt2BdId*4: Pt2BdId*4+4, ...]
    Pt2CrdG4 = np.dot(TransM02, Pt2Crd4.T)

    # Find unit cable force
    f = Pt1CrdG4[0:3] - Pt2CrdG4[0:3]
    f = f/np.linalg.norm(f)

    # Jc(CableID, j)=(rj x F) . zj AND ri = Pt - Oj
    # Note that Joint j is on Body j-1, which means O(j)=TransM0(j-1)
    # TODO: finish this part 
    for j in range(Pt2BdId - Pt1BdId):

        JtId = Pt2BdId-j

    return f