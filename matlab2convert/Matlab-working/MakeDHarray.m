function [ DHpara ] = MakeDHarray( q , uArm, lArm)
%MAKEDHARRAY Summary of this function goes here
%   DHpara=[a   d   alpha   theta]



DHpara(1,:)=[    0,    0,  pi/2, q(1)+pi/2];
DHpara(2,:)=[    0,    0,  pi/2, q(2)+pi/2];
DHpara(3,:)=[    0,-uArm,  pi/2, q(3)+pi/2];
DHpara(4,:)=[ lArm,    0,     0, q(4)-pi/2];

end

