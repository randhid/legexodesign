function [ effmax, effvert, sws] = wfw( Tmax, JcT, JeT , G)
%wfw find the wrench feasible workspace of the cable system at a give
%configuration.
%   Tmax is the maximum cable tension, Tmax should be a nJ dimensional
%   vector;
%   JcT is the transpose of cable Jacobian: JcT*T=U;
%   JeT is the transpose of end effector Jacobian: JeT*Fe=U;
%   G is the gravity vector, G should be a nJ dimensional vector.

%% Transform from Tension Space to Joint Space

[nJ , nCable]=size(JcT);
[nJ2, nEff  ]=size(JeT);
if nJ~=nJ2
    error 'Error: Row dimension of JcT and JeT should match';
elseif nCable~=length(Tmax)
    error 'Error: Tmax length should equal to column size of JcT';
end

if nargin<4 
    G=zeros(nJ,1); NoG=true;
elseif length(G)~=nJ
    error 'Error: G vector length should equal to row size of JcT';
else
    G=G(:); NoG=false;
end % Change G into column vector

TOL=1e-5;

%% Generate a square in tension space
Tn=zeros([nCable,2^nCable]);

for i=1:2^nCable
    for j=1:nCable
        Tn(j,i)=bitget(i-1,j)*Tmax(j);
    end
end

%% Transfer Tn (tension space) to Jn (joint space)
% Test the rank of JcT, and reduce it to full rank
[Q, R]=qr(JcT);
diagr=abs(diag(R));
r = find(diagr >= TOL*diagr(1), 1, 'last');
Jn=R(1:r,:)*Tn;
% Find the convex hull, and transfer back
k=convhulln(Jn');
kv=unique(k);
vertj=Q*[Jn(:,kv);zeros(nJ-r,length(kv))]; % vertices of available wrench in joint space
vertj=vertj-G(:,ones(1,length(kv)));

if r< nJ
    display('Low Rank Jc');
end
%% Transform from Eff Space to Joint Space and find if intersect
%   vertj rotated by u intersect at x(end-dimu:end)=0 plane 
%   is the eff space.

[u,s,v]=svd(JeT);    
% If s has almost 0 values, it mean the device is in a almost singular 
% configuration. It is very hard to generate torque at some direction.
% s=round(s,-log10(TOL));

dimu=nJ-rank(s);
vertj_u=u'*vertj;
vertj_u=round(vertj_u,-log10(TOL)); % Round to  precision

%% Test if intersection exist
% If there is intersection, the 
if any(all(vertj_u(end-dimu+1:end,:)>0,2) |...
       all(vertj_u(end-dimu+1:end,:)<0,2))
    % if no intersection, return 0 workspace
    effmax=0;
    effvert=[];
    sws=false;
    return;
end

%% If intersect
% Transfer V-poly to H-poly
[a,b,aeq1,beq1]=vert2lcon(vertj_u',1e-3);
aeq2=[zeros(dimu,nJ-dimu),eye(dimu)];
beq2=zeros(dimu,1);
x0=zeros([1,nJ]);

%% Test if wrench static, i.e. if origin inside wrench feasible
if ~NoG && ~all(a*x0'<=b)
    % if not wrench static
    if rank(s)==nEff
    vertj_u_intersect=lcon2vert(a,b,[aeq1;aeq2],[beq1;beq2],TOL,1);
    effvert=transpose(v*pinv(s)*vertj_u_intersect');
    else
        effvert=[];
    end
    effmax=0;
    sws=false;
else
    % if wrench static
    vertj_u_intersect=qlcon2vert(x0,a,b,[aeq1;aeq2],[beq1;beq2],TOL,1);
    effvert=transpose(v*pinv(s)*vertj_u_intersect'); 
    [~, dist, ~, ~]=vert2lcon(effvert);
    if isempty(dist)
        effmax=0;
    else
        effmax=min(abs(dist));
    end
    sws=true;
end

    


end

