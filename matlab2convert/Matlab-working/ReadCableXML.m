function [ CableCoord, Idx ] = ReadCableXML( xml_path )
%READCABLE Summary of this function goes here
%   Detailed explanation goes here

%%
clear;
xml_path='Routing.xml';
xDoc=xmlread(xml_path);
Routing=xDoc.getDocumentElement;
CableList=xDoc.getElementsByTagName('Cable');


%%
for i= 0: CableList.getLength-1
    Cable=CableList.item(i);
    CableID=Cable.getAttribute('id');
    CPointList=Cable.getElementsByTagName('RoutingPoint');
    for j= 0:CPointList.getLength-1
        CPoint=CPointList.item(j);
        CPoint.getElementsByTagName('Coordinates');
    end
end


end

