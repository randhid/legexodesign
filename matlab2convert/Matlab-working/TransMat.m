function [ TransM0 ] = TransMat( nJoint, Dharray )
%TRANSMAT Summary of this function goes here
%   Detailed explanation goes here
%%
TransM0=zeros(4*(nJoint+1),4);
TransM0(1:4,:)=eye(4);
for i =1 : nJoint
    TransM0(i*4+1:i*4+4,:)=TransM0(i*4-3:i*4,:)*DH(Dharray(i,:));
end

end

