function [ T ] = DH( dh )
%DH Summary of this function goes here
%   dh=[ a, d ,alpha, theta]

T=[cos(dh(4)),-sin(dh(4))*cos(dh(3)), sin(dh(4))*sin(dh(3)), dh(1)*cos(dh(4));
   sin(dh(4)), cos(dh(4))*cos(dh(3)),-cos(dh(4))*sin(dh(3)), dh(1)*sin(dh(4));
            0,            sin(dh(3)),            cos(dh(3)),           dh(2) ;
            0,                     0,                     0,              1  ];

end

