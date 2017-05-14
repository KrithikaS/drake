function [G] = getKukaArmGravityVector_J2toJ7(obj,q, c, s)

% link mass
m2=obj.m2; m3=obj.m3; m4=obj.m4; m5=obj.m5; m6=obj.m6; m7=obj.m7;

% link 3D position
l2x=obj.l2x; l2y=obj.l2y; l2z=obj.l2z;
l3x=obj.l3x; l3y=obj.l3y; l3z=obj.l3z;
l4x=obj.l4x; l4y=obj.l4y; l4z=obj.l4z;
l5x=obj.l5x; l5y=obj.l5y; l5z=obj.l5z;
l6x=obj.l6x; l6y=obj.l6y; l6z=obj.l6z;
l7x=obj.l7x; l7y=obj.l7y; l7z=obj.l7z;

% gravity constant
g=obj.g;

% CoM 3D position (with repsect to joint local coordinate)
c2x = obj.c2x; c2y = obj.c2y; c2z = obj.c2z;
c3x = obj.c3x; c3y = obj.c3y; c3z = obj.c3z;
c4x = obj.c4x; c4y = obj.c4y; c4z = obj.c4z;
c5x = obj.c5x; c5y = obj.c5y; c5z = obj.c5z;
c6x = obj.c6x; c6y = obj.c6y; c6z = obj.c6z;
c7x = obj.c7x; c7y = obj.c7y; c7z = obj.c7z;

% joint angle data

q2 = q(1);
q3 = q(2);
q4 = q(3);
q5 = q(4);
q6 = q(5);
q7 = q(6);


G1 = g*m2*(c2x*c(1) - c2y*s(1)) - g*m6*((409*s(1))/2000 - c(1)*(s(2)*(c6z*c(4) + c6y*s(4)*s(5)) + c(2)*((369*s(3))/2000 + s(3)*(c6y*c(5) + 431/2000) + c(3)*(c6z*s(4) - c6y*c(4)*s(5)))) + s(1)*((369*c(3))/2000 + c(3)*(c6y*c(5) + 431/2000) - s(3)*(c6z*s(4) - c6y*c(4)*s(5)) + 431/2000)) - g*m4*((409*s(1))/2000 + s(1)*(c4y*c(3) + 431/2000) + c(1)*(c4z*s(2) - c4y*c(2)*s(3))) - g*m7*((409*s(1))/2000 + s(1)*((369*c(3))/2000 + c(3)*((81*c(5))/1000 + c7z*c(5) + 431/2000) + c(4)*s(3)*((81*s(5))/1000 + c7z*s(5)) + 431/2000) - c(1)*(c(2)*((369*s(3))/2000 + s(3)*((81*c(5))/1000 + c7z*c(5) + 431/2000) - c(3)*c(4)*((81*s(5))/1000 + c7z*s(5))) + s(2)*s(4)*((81*s(5))/1000 + c7z*s(5)))) - g*m5*((409*s(1))/2000 + s(1)*((369*c(3))/2000 + c5z*c(3) - s(3)*(c5x*c(4) - c5y*s(4)) + 431/2000) - c(1)*(c(2)*((369*s(3))/2000 + c5z*s(3) + c(3)*(c5x*c(4) - c5y*s(4))) - s(2)*(c5y*c(4) + c5x*s(4)))) - g*m3*((409*s(1))/2000 + c3z*s(1) - c3y*c(1)*s(2));
G2 = g*m6*s(1)*(c(2)*(c6z*c(4) + c6y*s(4)*s(5)) - s(2)*((369*s(3))/2000 + s(3)*(c6y*c(5) + 431/2000) + c(3)*(c6z*s(4) - c6y*c(4)*s(5)))) - g*m7*s(1)*(s(2)*((369*s(3))/2000 + s(3)*((81*c(5))/1000 + c7z*c(5) + 431/2000) - c(3)*c(4)*((81*s(5))/1000 + c7z*s(5))) - c(2)*s(4)*((81*s(5))/1000 + c7z*s(5))) - g*m4*s(1)*(c4z*c(2) + c4y*s(2)*s(3)) - g*m5*s(1)*(s(2)*((369*s(3))/2000 + c5z*s(3) + c(3)*(c5x*c(4) - c5y*s(4))) + c(2)*(c5y*c(4) + c5x*s(4))) + c3y*g*m3*c(2)*s(1);
G3 = - g*m5*(c(1)*((369*s(3))/2000 + c5z*s(3) + c(3)*(c5x*c(4) - c5y*s(4))) - c(2)*s(1)*((369*c(3))/2000 + c5z*c(3) - s(3)*(c5x*c(4) - c5y*s(4)))) - g*m4*(c4y*c(1)*s(3) - c4y*c(2)*c(3)*s(1)) - g*m7*(c(1)*((369*s(3))/2000 + s(3)*((81*c(5))/1000 + c7z*c(5) + 431/2000) - c(3)*c(4)*((81*s(5))/1000 + c7z*s(5))) - c(2)*s(1)*((369*c(3))/2000 + c(3)*((81*c(5))/1000 + c7z*c(5) + 431/2000) + c(4)*s(3)*((81*s(5))/1000 + c7z*s(5)))) - g*m6*(c(1)*((369*s(3))/2000 + s(3)*(c6y*c(5) + 431/2000) + c(3)*(c6z*s(4) - c6y*c(4)*s(5))) - c(2)*s(1)*((369*c(3))/2000 + c(3)*(c6y*c(5) + 431/2000) - s(3)*(c6z*s(4) - c6y*c(4)*s(5))));
G4 = g*m7*s(5)*(c7z + 81/1000)*(c(4)*s(1)*s(2) - c(1)*s(3)*s(4) + c(2)*c(3)*s(1)*s(4)) - g*m5*(s(1)*(s(2)*(c5x*c(4) - c5y*s(4)) + c(2)*c(3)*(c5y*c(4) + c5x*s(4))) - c(1)*s(3)*(c5y*c(4) + c5x*s(4))) - g*m6*(s(1)*(s(2)*(c6z*s(4) - c6y*c(4)*s(5)) - c(2)*c(3)*(c6z*c(4) + c6y*s(4)*s(5))) + c(1)*s(3)*(c6z*c(4) + c6y*s(4)*s(5)));
G5 = - g*m7*(s(1)*(c(2)*(s(3)*((81*s(5))/1000 + c7z*s(5)) + c(3)*c(4)*((81*c(5))/1000 + c7z*c(5))) - s(2)*s(4)*((81*c(5))/1000 + c7z*c(5))) + c(1)*(c(3)*((81*s(5))/1000 + c7z*s(5)) - c(4)*s(3)*((81*c(5))/1000 + c7z*c(5)))) - g*m6*(c(1)*(c6y*c(3)*s(5) - c6y*c(4)*c(5)*s(3)) + s(1)*(c(2)*(c6y*s(3)*s(5) + c6y*c(3)*c(4)*c(5)) - c6y*c(5)*s(2)*s(4)));
G6 = 0;
G = [G1;G2;G3;G4;G5;G6];
end