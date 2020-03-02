function [ effmax, fe, sws] = wfw_old( Tmax, JcT, JeT , G)
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
if nJ~=nJ2 || nCable~=length(Tmax) || nJ~=length(G)
    display('Error input matrix dimension');
    return;
end

G=G(:);
%% Generate a square in tension space
Tn=zeros([nCable,2^nCable]);

for i=1:2^nCable
    for j=1:nCable
        Tn(j,i)=bitget(i-1,j);
    end
end

%% Transfer Tn (tension space) to Jn (joint space)
Jn=JcT*diag(Tmax)*Tn;
%  Remove inner points by finding the convex hull
k=convhulln(Jn'); 
kv=unique(k);
vertj=Jn(:,kv); % vertices of available wrench in joint space
vertj=vertj-G(:,ones(1,length(kv)));

%% Transform from Eff Space to Joint Space and find intersection
[u,s,v]=svd(JeT);        
dimu=length(s)-rank(s);
p_proj=u'*vertj;
%%

if any(all(p_proj(end-dimu+1:end,:)>=0,2) | all(p_proj(end-dimu+1:end,:)<=0,2))
    %% Intercect quick check
    fe=zeros([1,nEff]);
    effmax=0;

else
    %% If intersect
    % Transfer V-poly to H-poly
    aeq1=[];beq1=[];
    [a,b,aeq1,beq1]=vert2lcon(vertj',1e-5);
    % The projection of eff space to joint space
    aeq2=u(:,end-dimu+1:end)';
    beq2=zeros([dimu,1]);
    % where magic happens:

     x0=zeros([1,nJ]);
     vertf=qlcon2vert(x0,a,b,[aeq1;aeq2],[beq1;beq2],1e-5,1);
    % Above code is faster but cannot handle when G is present
    %vertf=lcon2vert(a,b,[aeq1;aeq2],[beq1;beq2],1e-3);
    
    % Transform from Joint Space to Eff Space
    fe=transpose(v*pinv(s)*u'*vertf');
    
    %fe=fe(:,unique(feorder));
    [~, dist, ~, ~]=vert2lcon(fe);
    effmax=min(abs(dist));
    
end

sws = 0; % This is only for output purpose. sws is not calculated.
end

