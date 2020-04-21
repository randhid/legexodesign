%%
x=[cos(0:0.02:pi*2);sin(0:0.02:pi*2)];
x1=[1;0];
x2=[0;1];


A=[ 0.3500,   -0.5100;
   -0.9100,   -0.0600;
   -0.3100,    0.8800];


[u, s, v]=svd(A);

xv=v'*x;
xv1=v'*x1;
xv2=v'*x2;
xs=s*xv;
xs1=s*xv1;
xs2=s*xv2;
y=A*x;
y1=A*x1;
y2=A*x2;

figure('Position',[0 0 1800 400]);
%%
subplot(1,4,1);
hold on;
line([0 0],[1.6 -1.6],'Color','w');
line([1.6 -1.6],[0 0],'Color','w');
orig=zeros(2);
ends=eye(2)*1.5;
quiver(orig(:,1),orig(:,2),ends(:,1),ends(:,2),0);
plot(x(1,:),x(2,:),'k');

h1=line([0,x1(1)],[0,x1(2)]);
h2=line([0,x2(1)],[0,x2(2)]);
h1.Color='r';
h2.Color='b';

box on;
xlabel('x_1');
ylabel('x_2');
title('x');
axis equal;
xlim([-2 2]);

%%

subplot(1,4,2);
hold on;
line([0 0],[1.6 -1.6],'Color','w');
line([1.6 -1.6],[0 0],'Color','w');
orig=zeros(2);
ends=eye(2)*1.5;
quiver(orig(:,1),orig(:,2),ends(:,1),ends(:,2),0);
plot(xv(1,:),xv(2,:),'k');
h1=line([0,xv1(1)],[0,xv1(2)]);
h2=line([0,xv2(1)],[0,xv2(2)]);
h1.Color='r';
h2.Color='b';

box on;
xlabel('x_1');
ylabel('x_2');
title('V^T \cdot x');
axis equal;
xlim([-2 2]);

%%

subplot(1,4,3);
hold on;
plot3(xs(1,:),xs(2,:),xs(3,:),'k');
plot3(y(1,:),y(2,:),y(3,:),'w');
h1=line([0,xs1(1)],[0,xs1(2)],[0,xs1(3)]);
h2=line([0,xs2(1)],[0,xs2(2)],[0,xs2(3)]);
h1.Color='r';
h2.Color='b';
orig=zeros(3);
ends=eye(3)*1.5;
quiver3(orig(:,1),orig(:,2),orig(:,3),ends(:,1),ends(:,2),ends(:,3),0);
view([48 16]);
xlabel('x_1');
ylabel('x_2');
zlabel('x_3');
title('S \cdot V^T \cdot x');
box on;
axis equal

%%

subplot(1,4,4);
hold on;
plot3(y(1,:),y(2,:),y(3,:),'k');
plot3(xs(1,:),xs(2,:),xs(3,:),'w');
h1=line([0,y1(1)],[0,y1(2)],[0,y1(3)]);
h2=line([0,y2(1)],[0,y2(2)],[0,y2(3)]);
h1.Color='r';
h2.Color='b';
orig=zeros(3);
ends=eye(3)*1.5;
quiver3(orig(:,1),orig(:,2),orig(:,3),ends(:,1),ends(:,2),ends(:,3),0);
view([48 16]);
xlabel('x_1');
ylabel('x_2');
zlabel('x_3');
title('A_e \cdot x = U \cdot S \cdot V^T \cdot x');
box on;
axis equal