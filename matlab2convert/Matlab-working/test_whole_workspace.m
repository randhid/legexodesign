%% 
clear;
load CarexRouting
uArm=0.32;
lArm=0.35;
nJoint=4;
nCable=7;
EffPt4=[0,0,0,1];
EffPtId=4;
Tmax=45*ones(1,7);
Gv=[0 -9.81 0];
BdWt=[0 0 0.71 0.6];
BdCoM4=[     0,     0,   0,   1;
             0,     0,   0,   1;
             0, 0.083,   0,   1;
        -0.185,     0,   0,   1];
    
t1=datetime;
%%
% Range to test: q1=[-25:80],q2=[-90:25],q3=[-70:80],q4=[0:90]
q1r=[-25,80];q2r=[-90,25];q3r=[-70,80];q4r=[0,90];
step=5;
cur_step=1;
total_step=(ceil(range(q1r)/step+1e-10))*(ceil(range(q2r)/step+1e-10))*...
           (ceil(range(q3r)/step+1e-10))*(ceil(range(q4r)/step+1e-10));
q1_step=total_step/ceil(range(q1r)/step+1e-10);
q2_step=q1_step/ceil(range(q2r)/step+1e-10);
q3_step=q2_step/ceil(range(q3r)/step+1e-10);

q_ws=zeros(total_step,4);
eff_ws=zeros(total_step,3);
effmax_ws=zeros(total_step,1);
test_ws=zeros(total_step,1);
sws_ws=zeros(total_step,1);

q_par4=zeros(q3_step,4);
eff_par4=zeros(q3_step,3);
effmax_par4=zeros(q3_step,1);
sws_par4=zeros(total_step,1);

for q1=q1r(1):step:q1r(2)
    for q2=q2r(1):step:q2r(2)
        for q3=q3r(1):step:q3r(2)         
            parfor parq4=1:ceil(90/step+1e-10)
                q4=(parq4-1)*step+0;
                qdeg=[q1,q2,q3,q4];
                idx=(q1-q1r(1))/step*q1_step + ...
                    (q2-q2r(1))/step*q2_step + ...
                    (q3-q3r(1))/step*q3_step + ...
                    (q4-q4r(1))/step+1;                               
                disp(strcat(num2str(idx),'/',num2str(total_step)));
                disp(strcat('q=[',num2str(qdeg),']'));
                %% Actual Test
                q=qdeg/180*pi;
                DHa=MakeDHarray( q , uArm, lArm);
                TransM0  = TransMat( nJoint, DHa );
                G=Gt(TransM0,BdWt,BdCoM4,Gv);
                Jc = JacobianCable(nJoint, nCable, TransM0, ...
                                   CableSeg, CbRtPtCrd, CbRtPtBdId );
                [Je, EffG] = JacobianPoint(TransM0,  EffPt4, EffPtId);
               
                [ effmax, fe, sws] = wfw( Tmax, Jc', Je', G );
                %%
                q_par4(parq4,:)=q;
                eff_par4(parq4,:)=EffG(1:3);
                effmax_par4(parq4)=effmax;
                sws_par4(parq4)=sws;
            end
            q3idx=(q1+25)/step*q1_step + ...
                  (q2+90)/step*q2_step + ...
                  (q3+70)/step*q3_step+1;
            q_ws(q3idx:q3idx+q3_step-1,:)=q_par4;
            eff_ws(q3idx:q3idx+q3_step-1,:)=eff_par4;
            effmax_ws(q3idx:q3idx+q3_step-1)=effmax_par4;
            test_ws(q3idx:q3idx+q3_step-1)=q3idx:q3idx+q3_step-1;
            
        end
    end
end
t2=datetime;
save wfw_carex effmax_ws eff_ws q_ws t1 t2
%%
display(t1);
display(t2);
rotG=[0 0 1; 1 0 0; 0 1 0];
tt=1:length(effmax_ws);
idx=tt(effmax_ws>0);
eff_wfw=eff_ws(idx,:)*rotG';

figure;
hold on;
plot3(eff_wfw(:,1),eff_wfw(:,2),eff_wfw(:,3),'.');
%%
for i=1:length(idx)
    %%
    DHa2=MakeDHarray( q_ws(idx(i),:) , uArm, lArm);
    TransM02  = TransMat( nJoint, DHa2 );
    [~, ElbPt] = JacobianPoint(TransM02,  EffPt4, 3);
    ElbPtG=(ElbPt(1:3).')*rotG';
    WrtPtG=eff_ws(idx(i),:)*rotG';
    plot3([0,ElbPt(1),WrtPtG(1)],[0,ElbPt(2),WrtPtG(2)],...
          [0,ElbPt(3),WrtPtG(3)],'r-');
end


xlabel('x');
ylabel('y');
zlabel('z');
axis equal;