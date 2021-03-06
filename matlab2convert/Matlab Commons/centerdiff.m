function [ dy, coef ] = centerdiff( y,n,dt )
%CENTERDIFF calculate the center difference of y of order n. The difference
%is taken at the 1st (column) dimension of y, i.e. dy=y(i+1,:)-y(i,:)
%   centerdiff(y) gives the first-order difference of y
%   centerdiff(y,n) gives the nth-order difference of y
%   centerdiff(y,n,dt) gives the nth-order derivitive of y:
%        centerdiff(y,n,dt)=centerdiff(y,n)/(dt^n)

%   Set dt = 1 if not set.
if nargin<3
    dt=1;
elseif dt<=0
    error('dt must be greater than 0');
end

if nargin<2
%   First order difference. Most common case.
%   dy=(y(i+1)-y(i-1))/2
    dy=(y(3:end,:)-y(1:end-2,:))/(2*dt);
else
%   n-order difference.
    if n>=length(y)
        error('Order n should be less that size of y');
    end

    if ~mod(n,2) 
    % n is even
        dy=zeros(size(y,1)-n,size(y,2));
        coef=zeros(n+1,1);
        for i=0:n
            coefi=(-1)^i*nchoosek(n,i);
            dy=dy+coefi*y(i+1:end-n+i,:);
            coef(i+1)=coefi;
        end
    else
    %   n is odd
        dy=zeros(size(y,1)-n-1,size(y,2));
        coef=zeros(n+2,1);
        for i=0:n+1
            if i==0 
                coefi=1/2;
            elseif i==n+1
                coefi=-1/2;
            else
                coefi=((-1)^(i-1)*nchoosek(n,i-1)+...
                     (-1)^i*nchoosek(n,i))/2;
            end
            dy=dy+coefi*y(i+1:end-n-1+i,:);
            coef(i+1)=coefi;
        end
    end
    dy=dy/(dt^n);
end


end

