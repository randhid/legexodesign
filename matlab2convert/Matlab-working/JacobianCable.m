function [ Jc ] = JacobianCable(nJoint, nCable,...
                    TransM0, CableSeg, CbRtPtCrd4, CbRtPtBdId )
%JC Summary of this function goes here
%   nBody denotes the number of bodies.
%   TransM is 4n by 4 matrix of transformation
%   CableSeg denote each segment of cable, in the format of:
%   [ CableID  Pt1  Pt2; ...];
%   CableID is the id of the Cable, Pt1 & Pt2 is the index in CbRtPtCrd and
%   CbRtPtBdId. 
%%
[nCableSeg,~]=size(CableSeg);

Jc=zeros(nCable, nJoint);
%%
for i=1:nCableSeg
    %%
    CableSegCurrent=CableSeg(i,:);
    CableID=CableSegCurrent(1);
    
    % Find Pt1 Coordinate in Global
    Pt1Crd4=CbRtPtCrd4(CableSegCurrent(2),:);
    Pt1BdId=CbRtPtBdId(CableSegCurrent(2),2)
    TransM01=TransM0(Pt1BdId*4+1:Pt1BdId*4+4,:);
    Pt1CrdG4=TransM01*Pt1Crd4';
    
    % Find Pt2 Coordinate in Global
    Pt2Crd4=CbRtPtCrd4(CableSegCurrent(3),:);
    Pt2BdId=CbRtPtBdId(CableSegCurrent(3),2)
    TransM02=TransM0(Pt2BdId*4+1:Pt2BdId*4+4,:);
    Pt2CrdG4=TransM02*Pt2Crd4';  
    
    % Find unit cable force
    f=Pt1CrdG4(1:3)-Pt2CrdG4(1:3);
    f=f/norm(f);
    %%
    % Jc(CableID, j)=(rj x F) . zj AND ri = Pt - Oj
    % Note that Joint j is on Body j-1, which means O(j)=TransM0(j-1)
    for j=1 : Pt2BdId - Pt1BdId
        %%
        JtId=Pt2BdId-(j-1);
        Oj=TransM0(JtId*4-3:JtId*4-1,4);
        zj=TransM0(JtId*4-3:JtId*4-1,3);
        Jj=dot(cross((Pt2CrdG4(1:3)-Oj),f),zj);
        Jc(CableID,JtId)=Jc(CableID,JtId)+Jj;
    end
        
    
end

return