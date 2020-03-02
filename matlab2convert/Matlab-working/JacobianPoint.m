function [ Jp, PtInGCS ] = JacobianPoint( TransM0,  PtInLCS, BodyID)
%Jp gives the Jacobian Matrix of any point on body.
%   TransM0 is the transformation matrix from DH variables;
%   Body ID is the Id of the body Pt is on;
%   PtInLCS is the coordinate of Pt in Local Coordinate System of Body ID;

Jp=zeros(3,BodyID);
PtInGCS=TransM0(4*BodyID+1:4*BodyID+4,:)*PtInLCS';

for i=1:BodyID
    
    Oi=TransM0(4*i-3:4*i-1,4);
    zi=TransM0(4*i-3:4*i-1,3);
    Jp(:,i)=cross(zi,(PtInGCS(1:3)-Oi));
end

end

