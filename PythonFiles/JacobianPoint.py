# REVIEW: Understand the concept

import numpy as np

# NOTE: Jp gives the Jacobian Matrix of any point on body.
#   TransM0 is the transformation matrix from DH variables;
#   Body ID is the Id of the body Pt is on;
#   PtInLCS is the coordinate of Pt in Local Coordinate System of Body ID;


def JacobianPoint(TransM0,  PtInLCS, BodyID):

    Jp = np.zeros((3,BodyID))                                           # initiate the jacobian
    PtInGCS = np.dot(TransM0[4*BodyID: 4*BodyID+4, :], PtInLCS.T)       # global coordinate

    for i in range(BodyID):

        Oi = TransM0[4*i: 4*i+3, 3]
        zi = TransM0[4*i: 4*i+3, 2]
        Jp[:, i] = np.cross(zi, (PtInGCS[0: 3] - Oi))

        # return (Jp, zi)

    return (Jp, PtInGCS)