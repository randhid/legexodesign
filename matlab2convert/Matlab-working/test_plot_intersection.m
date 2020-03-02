%% Initial Je and Eff Space
clear
x2=cos(0:0.01:pi*2);
y2=sin(0:0.01:pi*2);

feff=3;

Je=rand([3,2])*2-ones([3,2]);

p3=Je*feff*[x2;y2];

x3=p3(1,:);
y3=p3(2,:);
z3=p3(3,:);


%% Initiate Jf and Tension Space
ncable=4;
fn=zeros([ncable,2^ncable]);
for i=1:2^ncable
    fdec=dec2bin(i-1,ncable);
    for j=1:ncable
        fn(j,i)=str2num(fdec(j));
    end
end

fmax=10;
Jf=rand([3 ncable])*2-ones([3 ncable]);

%% Transform from Tension Space to Joint Space

p=fmax*Jf*fn;
 
hx=p(1,:)';
hy=p(2,:)';
hz=p(3,:)';
k=convhulln(p',{'QJ','Pp'});

%% Transfer V-poly to H-poly

kv=unique(k);
vertj=p(:,kv);
[a,b,aeq,beq]=vert2lcon(vertj',1e-3);

%% Transform from Eff Space to Joint Space and find intersection
[u,s,v]=svd(Je);        
dimu=rank(s)+1:length(s);
p_proj=u'*vertj;

if any(all(p_proj(dimu,:)>=0,2) | all(p_proj(dimu,:)<=0,2))
    %% If not interce
    vertf=zeros([1,length(u)]);
    fe=zeros([length(v),1]);
    fmax=0;
    vertforder=[1];
else
    aeq=u(:,dimu)';
    beq=zeros([1,range(dimu)+1]);
    x0=zeros([1,length(u)]);
    % where magic happens:
    vertf=qlcon2vert(x0,a,b,aeq,beq,1e-3,1);
    %vertf=lcon2vert(a,b,aeq,beq);
    %% Transform from Joint Space to Eff Space
    fe=v*pinv(s)*u'*vertf';
    feorder=convhulln(fe');
    fe=fe(:,unique(feorder));
    [a b aeq beq]=vert2lcon(fe');
    fmax=min(b);
    
    vertforder=[feorder(:,1);feorder(1)];
end

%%


%% Plot --  only works for 2D

vertfx=vertf(vertforder,1);
vertfy=vertf(vertforder,2);
vertfz=vertf(vertforder,3);

%% Joint Space
figure;
hold on;

hsurf=trimesh(k,hx,hy,hz,ones([length(hx),1]));
h.CDataMapping = 'scaled';
hsurf.FaceAlpha = 0.5;
plot3(x3,y3,z3,'-');
plot3(vertfx,vertfy,vertfz,'-','LineWidth',2);
plot3(0,0,0,'.r');

pxyz=Je*[1 -0.5 -0.5 1;1 1 -1 -1]*20;
hp=fill3(pxyz(1,:),pxyz(2,:),pxyz(3,:),'r');
hp.FaceAlpha=0.5;


axis equal;

%% Eff Space
figure;
hold on;

plot(feff*x2,feff*y2,'-b');
plot(fmax*x2,fmax*y2,'--b');
plot(fe(1,vertforder),fe(2,vertforder),'-r','LineWidth',2);
plot(0,0,'.r');
axis equal;

