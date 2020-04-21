function [h, x]=bartight(data, overallWidth,cmap)
% bartight(data, overall_width, colormap)
    [r,c] = size(data);    
    if nargin<3
        cmap=colormap(parula(c));
    end
    h = zeros(c,1);
    width = overallWidth / c;
    offset = width*(-(c/2-0.5):(c/2-0.5));
    x=bsxfun(@plus,repmat(1:r,c,1),offset');
    for i=1:c
        h(i) = bar(data(:,i),'FaceColor',cmap(i,:),'BarWidth',width);   
        set(h(i),'XData',get(h(i),'XData')+offset(i));
        hold on               
    end    
end