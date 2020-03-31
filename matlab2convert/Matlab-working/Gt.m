function [ G ] = Gt( TransM0, BdWt, BdCoM4 ,gv)
%Gt find the joint torque due to gravity
%   TransM0 are the transformation matrices;
%   BdWt is the weight of each body;
%   BdCoM4 is the center of mass of each body in LCS;
%   gv is the gravity vector, normally gv should be [0 0 -9.81].

nJ=length(TransM0)/4-1;
if nJ ~= length(BdWt)
    display('Error BdWt size');
    return;
end

G=zeros(1,nJ);

for i=1:nJ
    BdCoMLCS=TransM0(4*i+1:4*i+4,:)*BdCoM4(i,:)';
    Fi=BdWt(i)*gv;
    for j=1:i
        Oj=TransM0(4*j-3:4*j-1,4);
        zj=TransM0(4*j-3:4*j-1,3);
        Gij=dot(cross(BdCoMLCS(1:3)-Oj(1:3),Fi),zj);
        G(j)=G(j)+Gij;
    end
end



end

