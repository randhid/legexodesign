%% 
clear all;
clc;
load CarexRouting
uArm=0.32;
lArm=0.35;
%qdeg=[randi([-25 80]),randi([-90 25]),randi([-70 80]),randi([-0 90]),];
qdeg=[   35   -10    30     80];
q=qdeg/180*pi;
nJoint=4;
nCable=7;
EffPt4=[0,0,0,1];
EffPtId=4;
Tmax=45*ones(1,7);
Gv=[0 -9.81 0];
BdWt=[0 0 0.71 0.6];
%BdWt=[0 0 0 0];
BdCoM4=[     0,     0,   0,   1;
             0,     0,   0,   1;
             0, 0.083,   0,   1;
        -0.185,     0,   0,   1];


%%
DHa=MakeDHarray( q , uArm, lArm);

TransM0  = TransMat( nJoint, DHa );
G=Gt(TransM0,BdWt,BdCoM4,Gv);


Jc = JacobianCable(nJoint, nCable, TransM0, CableSeg, CbRtPtCrd, CbRtPtBdId );
 
[Je, Eff0] = JacobianPoint(TransM0,  EffPt4, EffPtId);

return

[ effmax, effvert, sws] = wfw( Tmax, Jc', Je' ,G);
%[ effmax2, effvert2, sws2] = wfw_old( Tmax, Jc', Je' , G);

%% wfw result
figure;
hold on;
if ~isempty(effvert)
    effvert=sort(effvert,1);
    effvert_order=convhulln(effvert);
    trimesh(effvert_order,effvert(:,1),effvert(:,2),effvert(:,3));
end
plot3(0,0,0,'.r');
xlabel('Fx');
ylabel('Fy');
zlabel('Fz');
axis equal;
view(15,20);

%% Arm configuration

rot0G=[0 0 1; 1 0 0; 0 1 0];
EffG=rot0G*Eff0(1:3);

display(qdeg);
display(EffG(:)');
display(effmax);
